package domain
package logic

import cats.effect.*
import cats.syntax.all.*
import com.monovore.decline.*
import com.monovore.decline.effect.*

import http_app.Main

case class RunHttpServer(port: Option[Int], dir: Option[String])
val showProcessesOpts: Opts[Option[Int]] = Opts.option[Int]("port", "The port.", short = "p").orNone
val showProcessesOpts2: Opts[Option[String]] = Opts.option[String]("dir", "The dir where to look for the mappings.", short = "d").orNone

case class GenerateProcessYamls(startPort: Int, dir: Option[String])
case class GenerateTraefik(dir: Option[String])
case class GenerateDockerImages(dir: Option[String])

val pathOpts: Opts[Int] = Opts.argument[Int](metavar = "startP")

val httpOpts: Opts[RunHttpServer] =
  Opts.subcommand("server", "Run http port mapping server."):
       (showProcessesOpts, showProcessesOpts2).mapN(RunHttpServer.apply)

val genYamls: Opts[GenerateProcessYamls] =
  Opts.subcommand("gen", "Generate compose files."):
       (pathOpts, showProcessesOpts2).mapN(GenerateProcessYamls.apply)

val genTraefik: Opts[GenerateTraefik] =
  Opts.subcommand("gen-traefik", "Generate traefik compose files."):
       showProcessesOpts2.map(GenerateTraefik.apply)

val genDockerImages: Opts[GenerateDockerImages] =
  Opts.subcommand("gen-docker", "Generate docker images file."):
       showProcessesOpts2.map(GenerateDockerImages.apply)

object InfrastructureApp extends CommandIOApp(
      name = "infrastructure-app",
      header = "util app...",
      version = "0.0.x"):

   override def main: Opts[IO[ExitCode]] = httpOpts.orElse(genYamls).orElse(genTraefik).orElse(genDockerImages).map:
        case RunHttpServer(port, dir)             => Main.run(1, "").as(ExitCode.Success)
        case GenerateTraefik(dir)                 => mainParamsTraefik().as(ExitCode.Success)
        case GenerateDockerImages(dir)            => mainConfig().as(ExitCode.Success)
        case GenerateProcessYamls(startPort, dir) => mainParams().as(ExitCode.Success)

// runMain domain.logic.InfrastructureApp server
// runMain domain.logic.InfrastructureApp server --port 8383
// runMain domain.logic.InfrastructureApp gen 1000 --dir out
// runMain domain.logic.InfrastructureApp gen-traefik --dir out
// runMain domain.logic.InfrastructureApp gen-docker --dir out
// https://ben.kirw.in/decline/effect.html
