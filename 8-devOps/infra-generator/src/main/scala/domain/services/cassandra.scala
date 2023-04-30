package domain
package services

import cats.syntax.option.*
import org.virtuslab.yaml.*

import domain.adts.*

class Cassandra(
  portConfig:  Int,
  host:        String,
  dataVolume:  String,
  name:        String,
  clusterName: String,
  image: String = "cassandra:5.0.5") extends Service:

   override val portsCount: Int = 1

   override def setPorts(ports: Int*): Unit = port = ports(0)

   var port: Int = 0

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
            "MAX_HEAP_SIZE" -> "256M",
            "HEAP_NEWSIZE" -> "128M",
            "CASSANDRA_CLUSTER_NAME" -> clusterName).some,
        ports = List(f"$port:9042"),
        volumes = List(f"$dataVolume:/var/lib/cassandra").some,
        networks = List("dev-network"),
        labels = List("type=cassandra").some)
      Map(name -> sb).asYaml.nullRemoved

   def toHAproxy =
     f"""
            |frontend tcp_front_${host.slugify}
            |    bind ${network.get.ip.dropRight(3)}:$portConfig
            |    mode tcp
            |    use_backend tcp_backend_${host.slugify}
            |
            |backend tcp_backend_${host.slugify}
            |    mode tcp
            |    server server1 localhost:$port
            |""".stripMargin

   def toDNSMasq: String = f"address=/${host}/${network.get.ip.dropRight(3)}"

   override def genMappings: Mappings = Mappings(
     host = host,
     ports = List(
       PortMap(
         fix = portConfig,
         variable = port)))
