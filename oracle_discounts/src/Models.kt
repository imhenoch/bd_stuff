data class Favorite(
    val email: String,
    val productId: Int,
    val product: String,
    val quantity: Int
)

data class Discount(
    val discountId: Int,
    val productId: Int,
    val description: String
)