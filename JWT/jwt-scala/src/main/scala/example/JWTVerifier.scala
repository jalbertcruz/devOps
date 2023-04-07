package example

import com.auth0.jwk.{Jwk, UrlJwkProvider}
import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.exceptions.{AlgorithmMismatchException, InvalidClaimException, JWTDecodeException, SignatureVerificationException, TokenExpiredException}
import com.auth0.jwt.interfaces.RSAKeyProvider

import java.nio.charset.StandardCharsets
import java.security.PublicKey
import java.security.interfaces.RSAPublicKey
import java.util.Base64
import scala.util.{Failure, Success, Try}

class JWTVerifier(
                   keysProvider: UrlJwkProvider
                 ) {

  private def getPublicKeyFromProvider(id: String): Jwk =
    keysProvider.get(id)

  def getPublicKey(id: String): PublicKey =
    getPublicKeyFromProvider(id).getPublicKey

  def verifyToken(token: String, issuer: String, algId: String) = {

    val pubKey = getPublicKey(algId)

    val onlyPublicKeyProvider = new RSAKeyProvider() {
      override def getPublicKeyById(keyId: String) = pubKey.asInstanceOf[RSAPublicKey]

      override def getPrivateKey = null

      override def getPrivateKeyId = null
    }


    val algorithmToVerify = Algorithm.RSA256(onlyPublicKeyProvider)

    val verifier = JWT.require(algorithmToVerify)
      .withIssuer(issuer)
      .build()

    val ver: Try[String] = Try {
      val jwt = verifier.verify(token)
      jwt.getPayload
    }

    ver match {
      case Success(e) =>
        val str = new String(
          Base64
            .getUrlDecoder
            .decode(
              e.getBytes(StandardCharsets.UTF_8)
            )
        )

        ujson.read(str).render(4)

      case Failure(exception: AlgorithmMismatchException) =>
        f"AlgorithmMismatchException ${exception.getMessage}"
      case Failure(exception: InvalidClaimException) =>
        f"InvalidClaimException ${exception.getMessage}"
      case Failure(exception: JWTDecodeException) =>
        f"JWTDecodeException ${exception.getMessage}"
      case Failure(exception: SignatureVerificationException) =>
        f"SignatureVerificationException ${exception.getMessage}"
      case Failure(exception: TokenExpiredException) =>
        f"TokenExpiredException ${exception.getMessage}"
      case Failure(exception) =>
        f"Other ${exception.getMessage}"
    }

  }

}
