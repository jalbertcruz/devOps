package domain
package services

import cats.syntax.option.*
import org.virtuslab.yaml.*
import domain.adts.{ DummyData, Mappings, PortMap, ProcessComposeBody }

class Jaeger(
  exporter_prometheus_port_config:             Int,
  query_http_host_port_config:                 Int,
  query_grpc_host_port_config:                 Int,
  remote_sampling_http_port_config:            Int,
  remote_sampling_grpc_port_config:            Int,
  otlp_grpc_port_config:                       Int,
  otlp_http_port_config:                       Int,
  jaeger_protocols_grpc_port_config:           Int,
  jaeger_protocols_thrift_http_port_config:    Int,
  jaeger_protocols_thrift_binary_port_config:  Int,
  jaeger_protocols_thrift_compact_port_config: Int,
  zipkin_port_config:                          Int,
  host:                                        String,
  name:                                        String,
  command:                                     String,
  working_dir: String) extends Service:

   var network: Option[DummyData] = None

   var exporter_prometheus_port: Int = 0
   var query_http_host_port: Int = 0
   var query_grpc_host_port: Int = 0
   var remote_sampling_http_port: Int = 0
   var remote_sampling_grpc_port: Int = 0
   var otlp_grpc_port: Int = 0
   var otlp_http_port: Int = 0
   var jaeger_protocols_grpc_port: Int = 0
   var jaeger_protocols_thrift_http_port: Int = 0
   var jaeger_protocols_thrift_binary_port: Int = 0
   var jaeger_protocols_thrift_compact_port: Int = 0
   var zipkin_port: Int = 0

   val portsCount = 12

   def setPorts(ports: Int*): Unit =
      this.exporter_prometheus_port = ports(0)
      this.query_http_host_port = ports(1)
      this.query_grpc_host_port = ports(2)
      this.remote_sampling_http_port = ports(3)
      this.remote_sampling_grpc_port = ports(4)
      this.otlp_grpc_port = ports(5)
      this.otlp_http_port = ports(6)
      this.jaeger_protocols_grpc_port = ports(7)
      this.jaeger_protocols_thrift_http_port = ports(8)
      this.jaeger_protocols_thrift_binary_port = ports(9)
      this.jaeger_protocols_thrift_compact_port = ports(10)
      this.zipkin_port = ports(11)

   def toYaml =
      val sb = ProcessComposeBody(
        command = command,
        working_dir = working_dir,
        environment =
          List(
            f"JAEGER_METRICS_READERS_EXPORTER_PROMETHEUS_PORT=$exporter_prometheus_port",
            f"JAEGER_QUERY_HTTP_HOST_PORT=$query_http_host_port",
            f"JAEGER_QUERY_GRPC_HOST_PORT=$query_grpc_host_port",
            f"JAEGER_REMOTE_SAMPLING_HTTP_PORT=$remote_sampling_http_port",
            f"JAEGER_REMOTE_SAMPLING_GRPC_PORT=$remote_sampling_grpc_port",
            f"JAEGER_RECEIVERS_OTLP_GRPC_PORT=$otlp_grpc_port",
            f"JAEGER_RECEIVERS_OTLP_HTTP_PORT=$otlp_http_port",
            f"JAEGER_RECEIVERS_JAEGER_PROTOCOLS_GRPC_PORT=$jaeger_protocols_grpc_port",
            f"JAEGER_RECEIVERS_JAEGER_PROTOCOLS_THRIFT_HTTP_PORT=$jaeger_protocols_thrift_http_port",
            f"JAEGER_RECEIVERS_JAEGER_PROTOCOLS_THRIFT_BINARY_PORT=$jaeger_protocols_thrift_binary_port",
            f"JAEGER_RECEIVERS_JAEGER_PROTOCOLS_THRIFT_COMPACT_PORT=$jaeger_protocols_thrift_compact_port",
            f"JAEGER_RECEIVERS_ZIPKIN_PORT=$zipkin_port").some)
      Map(name -> sb).asYaml.nullRemoved

   def genMappings: Mappings = Mappings(
     host = host,
     ports = List(
       PortMap(
         fix = exporter_prometheus_port_config,
         variable = exporter_prometheus_port),
       PortMap(
         fix = query_http_host_port_config,
         variable = query_http_host_port),
       PortMap(
         fix = query_grpc_host_port_config,
         variable = query_grpc_host_port),
       PortMap(
         fix = remote_sampling_http_port_config,
         variable = remote_sampling_http_port),
       PortMap(
         fix = remote_sampling_grpc_port_config,
         variable = remote_sampling_grpc_port),
       PortMap(
         fix = otlp_grpc_port_config,
         variable = otlp_grpc_port),
       PortMap(
         fix = otlp_http_port_config,
         variable = otlp_http_port),
       PortMap(
         fix = jaeger_protocols_grpc_port_config,
         variable = jaeger_protocols_grpc_port),
       PortMap(
         fix = jaeger_protocols_thrift_http_port_config,
         variable = jaeger_protocols_thrift_http_port),
       PortMap(
         fix = jaeger_protocols_thrift_binary_port_config,
         variable = jaeger_protocols_thrift_binary_port),
       PortMap(
         fix = jaeger_protocols_thrift_compact_port_config,
         variable = jaeger_protocols_thrift_compact_port),
       PortMap(
         fix = zipkin_port_config,
         variable = zipkin_port)))

   def toHAproxy =
     f"""
       |frontend tcp_front_exporter_prometheus_port_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$exporter_prometheus_port_config
       |    mode tcp
       |    use_backend tcp_backend_exporter_prometheus_port_${host.slugify}
       |
       |backend tcp_backend_exporter_prometheus_port_${host.slugify}
       |    mode tcp
       |    server server1 localhost:$exporter_prometheus_port
       |
       |frontend tcp_front_query_http_host_port_config_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$query_http_host_port_config
       |    mode tcp
       |    use_backend tcp_backend_query_http_host_port_config_${host.slugify}
       |
       |backend tcp_backend_query_http_host_port_config_${host.slugify}
       |    mode tcp
       |    server server1 localhost:$query_http_host_port
       |
       |frontend tcp_front_query_grpc_host_port_config_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$query_grpc_host_port_config
       |    mode tcp
       |    use_backend tcp_backend_query_grpc_host_port_config_${host.slugify}
       |
       |backend tcp_backend_query_grpc_host_port_config_${host.slugify}
       |    mode tcp
       |    server server1 localhost:$query_grpc_host_port
       |
       |frontend tcp_front_remote_sampling_http_port_config_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$remote_sampling_http_port_config
       |    mode tcp
       |    use_backend tcp_backend_remote_sampling_http_port_config_${host.slugify}
       |
       |backend tcp_backend_remote_sampling_http_port_config_${host.slugify}
       |    mode tcp
       |    server server1 localhost:$remote_sampling_http_port
       |
       |frontend tcp_front_remote_sampling_grpc_port_config_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$remote_sampling_grpc_port_config
       |    mode tcp
       |    use_backend tcp_backend_remote_sampling_grpc_port_config_${host.slugify}
       | 
       |backend tcp_backend_remote_sampling_grpc_port_config_${host.slugify}
       |    mode tcp
       |    server server1 localhost:$remote_sampling_grpc_port
       |
       |frontend tcp_front_otlp_grpc_port_config_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$otlp_grpc_port_config
       |    mode tcp
       |    use_backend tcp_backend_otlp_grpc_port_config_${host.slugify}
       |
       |backend tcp_backend_otlp_grpc_port_config_${host.slugify}
       |    mode tcp
       |    server server1 localhost:$otlp_grpc_port
       |
       |frontend tcp_front_otlp_http_port_config_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$otlp_http_port_config
       |    mode tcp
       |    use_backend tcp_backend_otlp_http_port_config_${host.slugify}
       |
       |backend tcp_backend_otlp_http_port_config_${host.slugify}
       |    mode tcp
       |    server server1 localhost:$otlp_http_port
       |
       |frontend tcp_front_jaeger_protocols_grpc_port_config_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$jaeger_protocols_grpc_port_config
       |    mode tcp
       |    use_backend tcp_backend_jaeger_protocols_grpc_port_config_${host.slugify}
       |
       |backend tcp_backend_jaeger_protocols_grpc_port_config_${host.slugify}
       |    mode tcp
       |    server server2 localhost:$jaeger_protocols_grpc_port
       |
       |frontend tcp_front_jaeger_protocols_thrift_http_port_config_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$jaeger_protocols_thrift_http_port_config
       |    mode tcp
       |    use_backend tcp_backend_jaeger_protocols_thrift_http_port_config_${host.slugify}
       |
       |backend tcp_backend_jaeger_protocols_thrift_http_port_config_${host.slugify}
       |    mode tcp
       |    server server2 localhost:$jaeger_protocols_thrift_http_port
       |
       |frontend tcp_front_jaeger_protocols_thrift_binary_port_config_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$jaeger_protocols_thrift_binary_port_config
       |    mode tcp
       |    use_backend tcp_backend_jaeger_protocols_thrift_binary_port_config_${host.slugify}
       |
       |backend tcp_backend_jaeger_protocols_thrift_binary_port_config_${host.slugify}
       |    mode tcp
       |    server server2 localhost:$jaeger_protocols_thrift_binary_port
       |
       |frontend tcp_front_jaeger_protocols_thrift_compact_port_config_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$jaeger_protocols_thrift_compact_port_config
       |    mode tcp
       |    use_backend tcp_backend_jaeger_protocols_thrift_compact_port_config_${host.slugify}
       |
       |backend tcp_backend_jaeger_protocols_thrift_compact_port_config_${host.slugify}
       |    mode tcp
       |    server server2 localhost:$jaeger_protocols_thrift_compact_port
       |
       |frontend tcp_front_zipkin_port_config_${host.slugify}
       |    bind ${network.get.ip.dropRight(3)}:$zipkin_port_config
       |    mode tcp
       |    use_backend tcp_backend_zipkin_port_config_${host.slugify}
       |
       |backend tcp_backend_zipkin_port_config_${host.slugify}
       |    mode tcp
       |    server server2 localhost:$zipkin_port
       |
       |""".stripMargin

   def toDNSMasq: String = f"address=/${host}/${network.get.ip.dropRight(3)}"
