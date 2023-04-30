package example

import com.auth0.jwk.{Jwk, UrlJwkProvider}
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.interfaces.RSAKeyProvider
import ujson.Obj

import java.math.BigInteger
import java.nio.charset.StandardCharsets
import java.security.interfaces.RSAPrivateKey
import java.security.{KeyFactory, PrivateKey}
import java.security.spec.RSAMultiPrimePrivateCrtKeySpec
import java.util
import java.util.{Base64, UUID}

class JWTGenerator(
                    keysProvider: UrlJwkProvider
                  ) {

 private def getPrivateKeyFromProvider(id: String): Jwk =
    keysProvider.get(id)

  private def getValues(
                         additionalAttributes: util.Map[String, AnyRef],
                         key: String
                       ) = new BigInteger(1, Base64.getUrlDecoder.decode(additionalAttributes.get(key).asInstanceOf[String]))

  def getPrivateKey(id: String): PrivateKey = {
    val privateKeyFromProvider = getPrivateKeyFromProvider(id)

    // https://github.com/auth0/jwks-rsa-java/issues/53
    val additionalAttributes = privateKeyFromProvider.getAdditionalAttributes
    val kf = KeyFactory.getInstance("RSA")

    val modules = getValues(additionalAttributes, "n")
    val publicExponent = getValues(additionalAttributes, "e")
    val privateExponent = getValues(additionalAttributes, "d")
    val primeP = getValues(additionalAttributes, "p")
    val primeQ = getValues(additionalAttributes, "q")
    val primeExponentP = getValues(additionalAttributes, "dp")
    val primeExponentQ = getValues(additionalAttributes, "dq")
    val crtCoefficient = getValues(additionalAttributes, "qi")

    val privateKeySpec = new RSAMultiPrimePrivateCrtKeySpec(modules, publicExponent, privateExponent, primeP, primeQ, primeExponentP, primeExponentQ, crtCoefficient, null)

    val privateKey: PrivateKey = kf.generatePrivate(privateKeySpec)
    privateKey

  }

  def exp(): Long = {
    val unixTime: Long = System.currentTimeMillis() / 1000L
    unixTime + 24 * 60 * 60
  }

  def nbf(): Long = {
    val unixTime: Long = System.currentTimeMillis() / 1000L
    unixTime - 24 * 60 * 60

  }
  def deleteLastEqualsSigns(str: String) = str.replaceAll("=*$", "")
  def getTokenSigned(
                    user_id: String,
                    iss: String,
                    aud: String,
                    roles: List[String],
                    algId: String
                    ) = {


    val jsonToken = ujson.Obj(
      "user_id" -> user_id,
      "iss" -> iss,
      "aud" -> aud,
      "jti" -> UUID.randomUUID().toString,
      "exp" -> ujson.Num(exp()),
      "nbf" -> ujson.Num(nbf()),
      "roles" -> ujson.Arr.from(roles)
    )


    val rawPayloadEncoded: String = getRawPayloadEncoded(jsonToken)
    val header = ujson.Obj("alg" -> "RS256", "kid" -> algId)
    val rawHeaderEncoded: String = getRawHeaderEncoded(header)
    val privateKey: PrivateKey = getPrivateKey(algId)

    val onlyPrivateKeyProvider = new RSAKeyProvider() {
      override def getPublicKeyById(keyId: String) = null

      override def getPrivateKey = privateKey.asInstanceOf[RSAPrivateKey]

      override def getPrivateKeyId = null
    }


    val algorithmToSign = Algorithm.RSA256(onlyPrivateKeyProvider)
    //    val algorithmToVerify = Algorithm.RSA256(onlyPublicKeyProvider)
    val headerEncoded = deleteLastEqualsSigns(rawHeaderEncoded)
    val payloadEncoded = deleteLastEqualsSigns(rawPayloadEncoded)

    val sRaw = algorithmToSign.sign(headerEncoded.getBytes, payloadEncoded.getBytes)

    val urlEncoder = Base64.getUrlEncoder
    val t = urlEncoder.encode(sRaw)
    val rawSignature = new String(t)

    val signature = deleteLastEqualsSigns(rawSignature)

    s"${headerEncoded}.${payloadEncoded}.${signature}"
  }

  private def getRawPayloadEncoded(jsonToken: ujson.Obj) = {
    val strPayload: String = jsonToken.render()
    val rPayload: Array[Byte] = urlEncode(strPayload)
    new String(rPayload)
  }

  private def getRawHeaderEncoded(header: ujson.Obj) = {
    val strHeader: String = header.render()
    val rHeader: Array[Byte] = urlEncode(strHeader)
    val rawHeaderEncoded = new String(rHeader)
    rawHeaderEncoded
  }

  private def urlEncode(strHeader: String) =
     Base64.getUrlEncoder.encode(strHeader.getBytes(StandardCharsets.UTF_8))


}
