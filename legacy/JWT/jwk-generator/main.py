# from authlib.jose import JsonWebKey
# from authlib.jose import JWK_ALGORITHMS

# from authlib.jose import jwk
import json

from  authlib.jose import JsonWebKey
import base64
params = {
    "kty": "RSA",
    "alg": "RS256",
}
#pr = jwk.dumps(open('private_key.pem').read(), kty='RSA', alg="RS256")
k=JsonWebKey.import_key(open('private_key.pem').read(), params)
encoded_data = base64.b64encode(k.thumbprint().encode('utf-8'))
print(encoded_data)


pr = dict(k)

#pu = jwk.dumps(open('public_key.pem').read(), kty='RSA', alg="RS256")
pu = dict(JsonWebKey.import_key(open('public_key.pem').read(), params))

alg_id = "id-1"
pr["kid"] = alg_id
pu["kid"] = alg_id

result = {
    "keys": [
        pr
    ]
}
open('jwks-priv.json', "w").write(json.dumps(result))

result = {
    "keys": [
        pu
    ]
}
open('jwks-pub.json', "w").write(json.dumps(result))
