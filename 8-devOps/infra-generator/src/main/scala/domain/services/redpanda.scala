package domain
package services

import cats.syntax.option.*
import org.virtuslab.yaml.*

import domain.adts.*

class Redpanda(
  name:                     String,
  schemaRegistryPortConfig: Int,
  pandaProxyPortConfig:     Int,
  portConfig:               Int,
  adminApiPortConfig:       Int,
  consolePortConfig:        Int,
  dataVolume:               String,
  host:                     String,
  image:                    String = "docker.redpanda.com/redpandadata/redpanda:v25.1.8",
  consoleImage: String = "docker.redpanda.com/redpandadata/console:v2.8.8") extends Service:

   var network: Option[DummyData] = None
   val portsCount = 5

   var schemaRegistryPort: Int = 0
   var pandaProxyPort: Int = 0
   var port: Int = 0
   var adminApiPort: Int = 0
   var consolePort: Int = 0

   def setPorts(ports: Int*): Unit =
      schemaRegistryPort = ports(0)
      pandaProxyPort = ports(1)
      port = ports(2)
      adminApiPort = ports(3)
      consolePort = ports(4)

   def toYaml =
      val sb = ServiceBody(
        image = image,
        hostname = host,
        profiles = List("tier-1"),
        command =
          List(
            "redpanda",
            "start",
            f"--kafka-addr internal://0.0.0.0:9092,external://0.0.0.0:$port",
            /*
        # Address the broker advertises to clients that connect to the Kafka API.
        # Use the internal addresses to connect to the Redpanda brokers'
        # from inside the same Docker network.
        # Use the external addresses to connect to the Redpanda brokers'
        # from outside the Docker network.
             * */
            f"--advertise-kafka-addr internal://$name:9092,external://localhost:$port",
            f"--pandaproxy-addr internal://0.0.0.0:8082,external://0.0.0.0:18082",
            // # Address the broker advertises to clients that connect to the HTTP Proxy.
            f"--advertise-pandaproxy-addr internal://redpanda:8082,external://localhost:$pandaProxyPort",
            f"--schema-registry-addr internal://0.0.0.0:8081,external://0.0.0.0:$schemaRegistryPort",
            // # Redpanda brokers use the RPC API to communicate with eachother internally.
            f"--rpc-addr $name:33145",
            f"--advertise-rpc-addr $name:33145",
            // # Tells Seastar (the framework Redpanda uses under the hood) to use 1 core on the system.
            "--smp 1",
            // # The amount of memory to make available to Redpanda.
            "--memory 1G",
            // # Mode dev-container uses well-known configuration properties for development in containers.
            "--mode dev-container",
            "--default-log-level=info").some,
        container_name = host.slugify,
        restart = "always",
        ports = List(
          f"$schemaRegistryPort:$schemaRegistryPort",
          f"$pandaProxyPort:$pandaProxyPort",
          f"$port:$port",
          f"$adminApiPort:9644"),
        volumes = Some(List(f"$dataVolume:/var/lib/redpanda/data")),
        networks = List("dev-network"))
      val content =
        f"""|
        kafka:
          brokers: ["$name:9092"]
          schemaRegistry:
            enabled: true
            urls: ["http://$name:8081"]
        redpanda:
          adminApi:
            enabled: true
            urls: ["http://$name:9644"]
         """
      val console = ServiceBody2(
        image = consoleImage,
        hostname = host,
        profiles = List("tier-1"),
        command = """-c 'echo "$$CONSOLE_CONFIG_FILE" > /tmp/config.yml; /app/console'""".some,
        container_name = f"${host.slugify}_console",
        restart = "always",
        environment =
          Map(
            "CONFIG_FILEPATH" -> "/tmp/config.yml",
            "CONSOLE_CONFIG_FILE" -> content).some,
        ports = List(
          f"$consolePort:8080"),
        networks = List("dev-network"),
        depends_on =
          List(
            name).some,
        entrypoint = "/bin/sh".some)
      Map(
        name -> sb).asYaml.nullRemoved + "\n"
      + Map(
        f"$name-console" -> console).asYaml.nullRemoved

   override def genMappings: Mappings = Mappings(
     host = host,
     ports = List(
       PortMap(
         fix = schemaRegistryPortConfig,
         variable = schemaRegistryPort),
       PortMap(
         fix = pandaProxyPortConfig,
         variable = pandaProxyPort),
       PortMap(
         fix = portConfig,
         variable = port),
       PortMap(
         fix = adminApiPortConfig,
         variable = adminApiPort),
       PortMap(
         fix = consolePortConfig,
         variable = consolePort)))

   def toHAproxy =
     f"""
       |frontend tcp_front_schemaRegistryPortConfig${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$schemaRegistryPortConfig
       |    mode tcp
       |    use_backend tcp_backend_schemaRegistryPortConfig${host.slugify}
       |
       |backend tcp_backend_schemaRegistryPortConfig${host.slugify}
       |    mode tcp
       |    server server1 localhost:$schemaRegistryPort
       |
       |frontend tcp_front_pandaProxyPortConfig${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$pandaProxyPortConfig
       |    mode tcp
       |    use_backend tcp_backend_pandaProxyPortConfig${host.slugify}
       |
       |backend tcp_backend_pandaProxyPortConfig${host.slugify}
       |    mode tcp
       |    server server1 localhost:$pandaProxyPort
       |
       |frontend tcp_front_portConfig${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$portConfig
       |    mode tcp
       |    use_backend tcp_backend_portConfig${host.slugify}
       |
       |backend tcp_backend_portConfig${host.slugify}
       |    mode tcp
       |    server server1 localhost:$port
       |
       |frontend tcp_front_adminApiPortConfig${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$adminApiPortConfig
       |    mode tcp
       |    use_backend tcp_backend_adminApiPortConfig${host.slugify}
       |
       |backend tcp_backend_adminApiPortConfig${host.slugify}
       |    mode tcp
       |    server server1 localhost:$adminApiPort
       |
       |frontend tcp_front_consolePortConfig${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$consolePortConfig
       |    mode tcp
       |    use_backend tcp_backend_consolePortConfig${host.slugify}
       |
       |backend tcp_backend_consolePortConfig${host.slugify}
       |    mode tcp
       |    server server1 localhost:$consolePort
       |
       |""".stripMargin

   def toDNSMasq: String = f"address=/${host}/${network.get.ip.dropRight(3)}"
