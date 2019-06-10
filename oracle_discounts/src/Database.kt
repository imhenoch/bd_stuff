import java.sql.Connection
import java.sql.DriverManager

private val DB_URL = "jdbc:oracle:thin:@host:sid"
private val USER = "user"
private val PASS = "pass"

private fun getConnection(): Connection {
    DriverManager.registerDriver(oracle.jdbc.driver.OracleDriver())
    return DriverManager.getConnection(DB_URL, USER, PASS)
}

fun getPreferedProduct(clientId: Int): Favorite? {
    var favorite: Favorite? = null
    try {
        val conn = getConnection()
        val statement = conn.createStatement()
        val rs = statement.executeQuery(
            "select " +
                    "c.\"email\", " +
                    "p.\"id_producto\", " +
                    "p.\"producto\", " +
                    "sum(tp.\"cantidad\") as \"cantidad\" " +
                    "from " +
                    "\"cliente\" c " +
                    "inner join \"transaccion\" t on c.\"id_cliente\" = t.\"id_cliente\" " +
                    "inner join \"transaccion_producto\" tp on t.\"id_transaccion\" = tp.\"id_transaccion\" " +
                    "inner join \"producto\" p on tp.\"id_producto\" = p.\"id_producto\" " +
                    "where " +
                    "c.\"id_cliente\" = $clientId " +
                    "group by " +
                    "c.\"email\", tp.\"id_producto\", p.\"producto\", p.\"id_producto\" " +
                    "order by " +
                    "\"cantidad\" desc " +
                    "fetch first 1 row only"
        )

        if (rs.next())
            favorite = Favorite(rs.getString(1), rs.getInt(2), rs.getString(3), rs.getInt(4))

        rs.close()
        statement.close()
        conn.close()
    } catch (ex: Exception) {
        ex.printStackTrace()
    } finally {
        return favorite
    }
}

fun getDiscount(favorite: Favorite): Discount? {
    var discount: Discount? = null
    try {
        val conn = getConnection()
        val statement = conn.createStatement()
        val rs = statement.executeQuery(
            "select " +
                    "*" +
                    "from " +
                    "\"promocion\" " +
                    "where " +
                    "\"id_producto\" = ${favorite.productId} " +
                    "fetch first 1 row only"
        )

        if (rs.next())
            discount = Discount(rs.getInt(1), rs.getInt(2), rs.getString(3))

        rs.close()
        statement.close()
        conn.close()
    } catch (ex: Exception) {
        ex.printStackTrace()
    } finally {
        return discount
    }
}

fun createDiscount(discount: Discount) {
    try {
        val conn = getConnection()
        val statement = conn.createStatement()
        statement.executeUpdate("insert into \"promocion\" (\"id_producto\", \"descripcion\") values(${discount.productId}, '${discount.description}')")

        statement.close()
        conn.close()
    } catch (ex: Exception) {
        ex.printStackTrace()
    }
}