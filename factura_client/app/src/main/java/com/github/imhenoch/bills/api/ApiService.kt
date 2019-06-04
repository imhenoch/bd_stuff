package com.github.imhenoch.bills.api

import com.github.imhenoch.bills.data.*
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Path

interface ApiService {
    @POST("rfc_exists")
    fun rfcExists(@Body client: Client): Call<RfcExists>

    @POST("client")
    fun createClient(@Body client: Client): Call<Result>

    @GET("cfdi")
    fun cfdi(): Call<List<CFDI>>

    @POST("bill")
    fun createBill(@Body bill: Bill): Call<Result>

    @GET("generate_bill/{transaction}")
    fun generateBill(@Path("transaction") transaction: Int): Call<Result>
}