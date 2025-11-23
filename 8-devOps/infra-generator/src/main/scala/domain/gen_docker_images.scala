package domain
package logic

import org.virtuslab.yaml.*

import adts.*

import java.nio.file.{ Files, Paths }

import distage.Injector
import Configs.*

import cats.*
import cats.effect.*

def mainConfig(): IO[Unit] =
   import DI.*

   val run =
     Injector[IO]().produceRun(configModule):
          (images: ImagesConfig) => {
            val imgs = Images(images = List(
              images.postgres_15,
              images.postgres_16,
              images.postgres_17,
              images.postgres_18,
              images.postgres_debian,
              images.postgis,
              images.mariadb,
              images.mysql,
              images.redpanda,
              images.redpanda_console,
              images.cassandra,
              images.latex,
              images.registry,
              images.dnsmasq,
              images.traefik,
              images.rabbitmq,
              images.stirlingtools,
              images.penpotapp_frontend,
              images.penpotapp_backend,
              images.penpotapp_exporter,
              images.penpotapp_mailcatch,
              images.valkey,
            ))
            val entry = imgs.asYaml.nullRemoved
            Files.write(Paths.get(f"out/docker-images.yaml"), entry.getBytes)

            IO { () }
          }
   run
