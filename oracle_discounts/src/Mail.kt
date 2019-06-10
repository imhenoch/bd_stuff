import java.util.*
import javax.mail.*
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage

private val HOST = "smtp.gmail.com"
private val USERNAME = "user"
private val PASSWORD = "pass"
private val FROM = "mail"

fun sendMail(discount: Discount, favorite: Favorite) {
    val host = HOST
    val port = "587"
    val username = USERNAME
    val password = PASSWORD

    val prop = Properties()
    prop["mail.smtp.host"] = host
    prop["mail.smtp.port"] = port
    prop["mail.smtp.auth"] = "true"
    prop["mail.smtp.starttls.enable"] = "true"

    val session = Session.getInstance(
        prop,
        object : Authenticator() {
            override fun getPasswordAuthentication(): PasswordAuthentication {
                return PasswordAuthentication(username, password)
            }
        }
    )

    try {
        val message = MimeMessage(session)
        message.setFrom(InternetAddress(FROM))
        message.setRecipients(
            Message.RecipientType.TO,
            InternetAddress.parse(favorite.email)
        )
        message.subject = "DISCOUNT on \"${favorite.product}\""
        message.setText(discount.description)

        Transport.send(message)

        println("Email send to ${favorite.email}")
    } catch (ex: MessagingException) {
        ex.printStackTrace()
    }
}