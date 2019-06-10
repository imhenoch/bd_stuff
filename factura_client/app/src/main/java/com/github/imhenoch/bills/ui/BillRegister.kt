package com.github.imhenoch.bills.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.Toast
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.github.imhenoch.bills.BuildConfig
import com.github.imhenoch.bills.R
import com.github.imhenoch.bills.api.ApiService
import com.github.imhenoch.bills.data.*
import com.github.imhenoch.bills.databinding.BillRegisterBinding
import okhttp3.OkHttpClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

class BillRegister : Fragment() {
    private lateinit var binding: BillRegisterBinding
    private val FIRST_STAGE = 1
    private val MIDDLE_STAGE = 2
    private val LAST_STAGE = 3
    private val retrofit by lazy {
        Retrofit.Builder()
            .baseUrl("http://${BuildConfig.IP}:${BuildConfig.PORT}")
            .client(
                OkHttpClient
                    .Builder()
                    .connectTimeout(30, TimeUnit.SECONDS)
                    .readTimeout(30, TimeUnit.SECONDS)
                    .writeTimeout(30, TimeUnit.SECONDS)
                    .build()
            )
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }
    private val api by lazy {
        retrofit.create(ApiService::class.java)
    }
    private lateinit var client: Client
    private lateinit var bill: Bill

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = DataBindingUtil.inflate(
            inflater,
            R.layout.bill_register,
            container,
            false
        )
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        callbacks()
        initState()
    }

    private fun callbacks() {
        binding.cancelLast.setOnClickListener { initState() }
        binding.cancelMiddle.setOnClickListener { initState() }
        binding.continueFirst.setOnClickListener { firstState() }
        binding.continueMiddle.setOnClickListener { middleState() }
        binding.continueLast.setOnClickListener { finalState() }
    }

    private fun initState() {
        binding.stage = FIRST_STAGE
        binding.executePendingBindings()
        binding.etRFC.text?.clear()
        binding.etTransaction.text?.clear()
        binding.executePendingBindings()
    }

    private fun firstState() {
        client = Client(binding.etRFC.text.toString())
        bill = Bill(client.rfc, Integer.parseInt(binding.etTransaction.text.toString()))
        api.rfcExists(client).enqueue(object : Callback<RfcExists> {
            override fun onFailure(call: Call<RfcExists>, t: Throwable) {
                t.printStackTrace()
                initState()
            }

            override fun onResponse(call: Call<RfcExists>, response: Response<RfcExists>) {
                response.body()?.let {
                    if (it.rfcExists)
                        getCFDIS()
                    else {
                        binding.stage = MIDDLE_STAGE
                        binding.executePendingBindings()
                    }
                }
            }
        })
    }

    private fun middleState() {
        client = client.copy(social = binding.etSocial.text.toString(), address = binding.etAddress.text.toString())
        api.createClient(client).enqueue(object : Callback<Result> {
            override fun onFailure(call: Call<Result>, t: Throwable) {
                initState()
            }

            override fun onResponse(call: Call<Result>, response: Response<Result>) {
                getCFDIS()
            }
        })
    }

    private fun getCFDIS() {
        api.cfdi().enqueue(object : Callback<List<CFDI>> {
            override fun onFailure(call: Call<List<CFDI>>, t: Throwable) {
                initState()
            }

            override fun onResponse(call: Call<List<CFDI>>, response: Response<List<CFDI>>) {
                response.body()?.let {
                    binding.spCfdi.adapter = ArrayAdapter(context!!, android.R.layout.simple_spinner_item, it)
                    binding.stage = LAST_STAGE
                    binding.executePendingBindings()
                }
            }
        })
    }

    private fun finalState() {
        bill = bill.copy(cfdi = (binding.spCfdi.selectedItem as CFDI).cfdi)
        api.createBill(bill).enqueue(object : Callback<Result> {
            override fun onFailure(call: Call<Result>, t: Throwable) {
                initState()
            }

            override fun onResponse(call: Call<Result>, response: Response<Result>) {
                api.generateBill(bill.trasaction).enqueue(object : Callback<Result> {
                    override fun onFailure(call: Call<Result>, t: Throwable) {
                        initState()
                    }

                    override fun onResponse(call: Call<Result>, response: Response<Result>) {
                        Toast.makeText(context!!, "Bill created", Toast.LENGTH_LONG).show()
                        initState()
                    }
                })
            }
        })
    }
}