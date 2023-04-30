val scala3Version = "3.7.4"
val izumi = "1.2.20"
val circeVersion = "0.14.14"

lazy val root = project
  .in(file("."))
  .enablePlugins(Smithy4sCodegenPlugin)
  .settings(
    name := "infra-generator",
    version := "0.1.0",
    scalaVersion := scala3Version,
    libraryDependencies ++= Seq(
      "org.scalameta"                %% "munit"                    % "1.0.0" % Test,
      "org.virtuslab"                %% "scala-yaml"               % "0.3.0",
      "com.github.slugify"            % "slugify"                  % "3.0.7",
      "org.typelevel"                %% "cats-core"                % "2.13.0",
      "org.tpolecat"                 %% "doobie-core"              % "1.0.0-RC10",
      "org.tpolecat"                 %% "doobie-mysql"             % "1.0.0-RC10",
      "org.tpolecat"                 %% "doobie-postgres"          % "1.0.0-RC10",
//      "org.tpolecat" %% "doobie-postgres-circe" % "1.0.0-RC10",
      "org.postgresql"                % "postgresql"               % "42.7.7",
      "com.mysql"                     % "mysql-connector-j"        % "9.4.0",
      "io.7mind.izumi"               %% "distage-extension-config" % izumi,
      "io.7mind.izumi"               %% "distage-core"             % izumi,
      "com.disneystreaming.smithy4s" %% "smithy4s-http4s"          % smithy4sVersion.value,
      "org.http4s"                   %% "http4s-ember-server"      % "0.23.30",
      "com.monovore"                 %% "decline-effect"           % "2.5.0") ++
    Seq(
      "io.circe" %% "circe-core",
      "io.circe" %% "circe-generic",
      "io.circe" %% "circe-parser").map(_ % circeVersion),
    Compile / run / fork := true,
    Compile / run / connectInput := true,
    scalacOptions ++=
      Seq(
        "-explain",
        "-Wsafe-init",
        "-deprecation", // show deprecation warnings
        //      "-unchecked",       // additional warnings
        //      "-Xfatal-warnings", // treat warnings as errors
        "-feature",
        "-Xmax-inlines",
        "50",
        // "-Yexplicit-nulls",
      ) ++ scalacOptionsValue)

lazy val scalacOptionsCustom = sys.env.getOrElse("SCALAC_OPTIONS", "default")
lazy val scalacOptionsValue = scalacOptionsCases(scalacOptionsCustom)

lazy val scalacOptionsCases = Map(
  "default" -> Seq[String](),
  "new_syntax" -> Seq[String]("-new-syntax", "-rewrite"),
  "indent" -> Seq[String]("-Wunused:all", "-indent", "-rewrite"),
  "3_7_migration" -> Seq[String]("-rewrite", "-source", "3.7-migration"),
  "future_migration" -> Seq[String]("-rewrite", "-indent", "-source", "future-migration"),
)
