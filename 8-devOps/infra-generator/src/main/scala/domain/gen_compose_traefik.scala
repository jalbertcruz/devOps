package domain
package logic

import io.circe.*, io.circe.generic.auto.*, io.circe.syntax.*

import adts.*

import java.nio.file.{ Files, Paths }

import distage.Injector
import Configs.*

import cats.*, cats.implicits.*
import cats.effect.*

// This is just for testing. Consider using cats.effect.IOApp instead of calling
// unsafe methods directly.

//@main
def mainParamsTraefik(): IO[Unit] =
   import DI.*

   val run =
     Injector[IO]().produceRun(configModule):
          (images: ImagesConfig) => {

            val outPath = "out"
            val conf = ConfigurationTraefik(postgres =
              List(
                PostgresConfig(
                  host = "postgresql-services-1.personal.local",
                  volume = "postgresql-services-1-data"),
//          PostgresConfig(
//            host = "postgres-2.personal.local",
//            volume = "postgres-2-data"
//          ),
              ).some)
            val dcservices: List[(String, Option[List[services.Service]])] = List(
              (
                "postgres",
                conf.postgres.map:
                     s =>
                        s.zipWithIndex.map:
                             case (PostgresConfig(host, vol), index) => {
                               services.Postgres(
                                 id = index + 1,
                                 port = 3306,
                                 dataVolume = vol,
                                 host = host,
                                 name = f"postgres-${index + 1}",
                                 image = images.postgres_18)
                             },
              ))

            //      val xx: List[Option[List[services.Service]]] = dcservices.map(_._2)
            val dcsf: List[services.Service] = dcservices.map(_._2).flatten.flatten

            val mappingsL: List[Mappings] = dcsf.map(_.genMappings)
            val json = mappingsL.asJson.noSpaces
            Files.write(Paths.get(f"out/mappings2.json"), json.getBytes)

            dcservices.foreach(
              (n, ss) => {
                ss.foreach {
                  sss =>
                    sss.zipWithIndex.foreach(
                      (s, i) => {
                        val entry = s.toYaml
                        Files.write(Paths.get(f"out/$n/$n-${i + 1}.yaml"), entry.getBytes)
                      })
                }
              })

            IO { () }
          }
   run
