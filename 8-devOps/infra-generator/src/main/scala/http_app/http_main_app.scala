package http_app

import hello.*
import cats.syntax.all.*
import org.http4s.implicits.*
import org.http4s.ember.server.*
import org.http4s.*
import com.comcast.ip4s.*
import smithy4s.http4s.SimpleRestJsonBuilder
import scala.concurrent.duration.*

import cats.effect.*

import domain.adts.*
import scala.io.Source

import io.circe.*, io.circe.generic.auto.*, io.circe.parser.*

class HelloWorldImpl(mpps: Map[String, Map[Int, Int]]) extends HelloWorldService[IO]:

   def hello(host: String, port: Int): IO[Greeting] = IO.pure:
        Greeting(mpps(host)(port))

object Routes:

   def getMappings() =
      val s = Source.fromFile("out/mappings2.json")
      val content = s.getLines().mkString
      s.close()
      val s2 = Source.fromFile("out/mappings.json")
      val content2 = s2.getLines().mkString
      s2.close()
      val mappings = decode[List[Mappings]](content).toOption.get
      val mappingsE = decode[List[Mappings]](content2)
      val mappings2 = decode[List[Mappings]](content2).toOption.get

      Map.from(mappings.map(
        entry => {
          (
            entry.host,
            Map.from(entry.ports.map(
              (p: PortMap) => {
                (p.fix, p.variable)
              })))
        })
        ++ mappings2.map(
          entry => {
            (
              entry.host,
              Map.from(entry.ports.map(
                (p: PortMap) => {
                  (p.fix, p.variable)
                })))
          }))

   private val example: Resource[IO, HttpRoutes[IO]] = SimpleRestJsonBuilder.routes(HelloWorldImpl(getMappings())).resource

   val all: Resource[IO, HttpRoutes[IO]] = example

object Main
//  extends IOApp.Simple
:

   def run(port: Int, dir: String) = Routes.all
     .flatMap:
        routes =>
           val thePort = port"9004"
           val theHost = host"0.0.0.0"
           val message = s"Server started on: $theHost:$thePort, press enter to stop"

           EmberServerBuilder
             .default[IO]
             .withPort(thePort)
             .withHost(theHost)
             .withHttpApp(routes.orNotFound)
             .withShutdownTimeout(1.second)
             .build
             .productL(IO.println(message).toResource)
     .surround(IO.readLine)
     .void
     .guarantee(IO.println("Goodbye!"))
