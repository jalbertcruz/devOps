package domain
package services

import cats.syntax.option.*
import org.virtuslab.yaml.*

import domain.adts.*

class MinIO(
  portConfig:        Int,
  consolePortConfig: Int,
  host:              String,
  name:              String,
  command:           String,
  working_dir: String) extends Service:

   var port: Int = 0
   var consolePort: Int = 0

   var network: Option[DummyData] = None
   override val portsCount: Int = 2

   override def setPorts(ports: Int*): Unit =
      port = ports(0)
      consolePort = ports(1)

   override def toYaml: String =
      val sb = ProcessComposeBody(
        command = command,
        working_dir = working_dir,
        environment =
          List(
            f"MINIO_ADDRESS=:$port",
            f"MINIO_CONSOLE_ADDRESS=:$consolePort").some)
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
       |
       |frontend tcp_front_console_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$consolePortConfig
       |    mode tcp
       |    use_backend tcp_backend_console_${host.slugify}
       |
       |backend tcp_backend_console_${host.slugify}
       |    mode tcp
       |    server server1 localhost:$consolePort
       |
       |""".stripMargin

   def toDNSMasq: String = f"address=/${host}/${network.get.ip.dropRight(3)}"

   override def genMappings: Mappings = Mappings(
     host = host,
     ports = List(
       PortMap(
         fix = portConfig,
         variable = port),
       PortMap(
         fix = consolePortConfig,
         variable = consolePort)))
