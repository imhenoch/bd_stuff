import java.util.*

fun main(args: Array<String>) {
    val scanner = Scanner(System.`in`)
    print("Client id: ")
    val clientId = scanner.nextInt()
    val favorite = getPreferedProduct(clientId)
    favorite?.let { f ->
        val discount = getDiscount(favorite)
        if (discount == null) {
            println("There's no available discount for \"${f.product}\", create one")
            println("\nDiscount details: ")
            val newDiscount = Discount(0, f.productId, scanner.next().replace("_", " "))
            createDiscount(newDiscount)
            sendMail(newDiscount, f)
        } else {
            sendMail(discount, f)
        }
    }
}