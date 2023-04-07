package example

import com.auth0.jwk.UrlJwkProvider

import java.io.File

object Hello extends App {

  private def privateKeysProviderFromFile() = {
    val f = new File("/home/a/src/devOps/jwk-generator/jwks-priv.json")
    val url = f.toURI.toURL
    new UrlJwkProvider(url)
  }

  private def publicKeysProviderFromFile() = {
    val f = new File("/home/a/src/devOps/jwk-generator/jwks-pub.json")
    val url = f.toURI.toURL
    new UrlJwkProvider(url)
  }


  def getToken(algId: String) = {

    val obj = new JWTGenerator(
      privateKeysProviderFromFile()
    )


    obj.getTokenSigned(
      "usr_1",
      "http://company.com",
      "http://company.com",
      List("user", "admin"),
      algId = algId
    )
  }

  val algId = "alg1"

  val tk = getToken(algId)
  val verifier = new JWTVerifier(
    publicKeysProviderFromFile()
  )

  println(tk)

  val res = verifier.verifyToken(tk, "http://company.com", algId)

  println(s"payload: ${res}")


}
