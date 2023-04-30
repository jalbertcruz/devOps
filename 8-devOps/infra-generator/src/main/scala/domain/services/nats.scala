package domain
package services

import cats.syntax.option.*
import org.virtuslab.yaml.*

import domain.adts.*

class Nats(
  portConfig: Int,
  host:       String,
  name:       String,
  command:    String,
  working_dir: String) extends Service:

   override val portsCount: Int = 1

   override def setPorts(ports: Int*): Unit = port = ports(0)

   var port: Int = 0

   var network: Option[DummyData] = None

   override def toYaml: String =
      val sb = ProcessComposeBody(
        command = command,
        working_dir = working_dir,
        environment =
          List(
            f"NATS_PORT=$port").some)
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
