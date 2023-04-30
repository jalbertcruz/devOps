package domain
package services

import cats.syntax.option.*
import org.virtuslab.yaml.*

import domain.adts.*

class Postgres(
  id:         Int,
  port:       Int,
  host:       String,
  dataVolume: String,
  name:       String,
  image: String = "postgres:17.5-alpine3.22") extends Service:

   override val portsCount: Int = 0

   override def setPorts(ports: Int*): Unit = {}

   var network: Option[DummyData] = None

   override def toYaml: String =
      val sb = ServiceBody(
        image = image,
        profiles = List("tier-1"),
        container_name = host.slugify,
        hostname = host,
        restart = "always",
        environment =
          Map(
            "POSTGRES_PASSWORD" -> "dpass",
            "POSTGRES_USER" -> "duser",
            "POSTGRES_DB" -> "service").some,
        ports = List(f"5432"),
        volumes = List(f"$dataVolume:/var/lib/postgresql/data").some,
        networks = List("dev-network"),
        labels =
          List(
            "traefik.enable=true",
            "traefik.docker.network=dev-network",
            f"traefik.tcp.routers.tcprouter-postgres-$id.entryPoints=postgres",
            f"traefik.tcp.routers.tcprouter-postgres-$id.rule=HostSNI(`$host`)",
            f"traefik.tcp.routers.tcprouter-postgres-$id.service=postgres-$id",
            f"traefik.tcp.routers.tcprouter-postgres-$id.tls=true",
            f"traefik.tcp.services.postgres-$id.loadbalancer.server.port=5432",
            "type=postgres").some)
      Map(name -> sb).asYaml.nullRemoved

   def toHAproxy = ""

   def toDNSMasq: String = ""

   override def genMappings: Mappings = Mappings(
     host = host,
     ports = List(
       PortMap(
         fix = port,
         variable = port)))
