package com.github.imhenoch.bills

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.github.imhenoch.bills.ui.BillRegister

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        initUI()
    }

    private fun initUI() {
        supportFragmentManager
            .beginTransaction()
            .replace(
                R.id.bill_content,
                BillRegister()
            )
            .commit()
    }
}