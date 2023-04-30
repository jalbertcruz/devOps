
lazy val root = (project in file("."))
  .settings(
    scalaVersion     := "2.13.5",
    version          := "0.1.0-SNAPSHOT",
    organization     := "com.example",
    organizationName := "example",
    name := "jwt-scala",
    libraryDependencies ++= Seq(
      "com.auth0" % "jwks-rsa" % "0.17.0",
      "com.auth0" % "java-jwt" %  "3.14.0",
      "com.lihaoyi" %% "requests" % "0.6.5",
      "com.lihaoyi" %% "ujson" % "1.2.3",
      "org.bouncycastle" % "bcprov-jdk15on" % "1.68",
    )
  )

// See https://www.scala-sbt.org/1.x/docs/Using-Sonatype.html for instructions on how to publish to Sonatype.

addCommandAlias("r", ";run")
addCommandAlias("t", ";test")
addCommandAlias("rl", ";reload")
addCommandAlias("c", ";compile")
addCommandAlias("p", ";universal:packageZipTarball")
addCommandAlias("d", ";docker:publishLocal")
addCommandAlias("fmt", ";scalafmtAll")
addCommandAlias("f", ";scalafmtAll;scalafixAll")
addCommandAlias("fck", ";scalafixAll --check")
