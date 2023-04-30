$version: "2"

namespace hello

use alloy#simpleRestJson

@simpleRestJson
service HelloWorldService {
  version: "1.0.0",
  operations: [Hello]
}

@readonly
@http(method: "GET", uri: "/get-port", code: 200)
operation Hello {
  input: Person,
  output: Greeting
}

structure Person {
  @httpQuery("host")
  @required
  host: String,

  @httpQuery("port")
  @required
  port: Integer
}

structure Greeting {
  @required
  port: Integer
}
