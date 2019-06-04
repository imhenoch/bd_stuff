package com.github.imhenoch.bills.data

import com.google.gson.annotations.SerializedName

data class RfcExists(
    @SerializedName("rfc_exists") val rfcExists: Boolean
)

data class Client(
    @SerializedName("rfc") val rfc: String,
    @SerializedName("razon_social") var social: String = "",
    @SerializedName("domicilio") var address: String = ""
)

data class Bill(
    @SerializedName("rfc") val rfc: String,
    @SerializedName("transaccion") val trasaction: Int,
    @SerializedName("cfdi") var cfdi: String = ""
)

data class Result(
    @SerializedName("result") val result: String
)

data class CFDI(
    @SerializedName("cfdi") val cfdi: String,
    @SerializedName("descripcion") val description: String
) {
    override fun toString(): String {
        return "$cfdi - $description"
    }
}