import PluginsDependencies.Vp

addSbtPlugin(
  "com.disneystreaming.smithy4s" % "smithy4s-sbt-codegen" % Vp.smithy4s)

addSbtPlugin("ch.epfl.scala" % "sbt-bloop" % "2.0.10")

addSbtPlugin(
  "ch.epfl.scala" % "sbt-scalafix" % Vp.sbt_scalafix)

addSbtPlugin(
  "org.scalameta" % "sbt-scalafmt" % Vp.sbt_scalafmt)
