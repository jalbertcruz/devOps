package domain
package logic

import cats.*
import cats.effect.*
import cats.syntax.option.*
import distage.Injector
import domain.Configs.*
import domain.adts.*
import io.circe.*
import io.circe.generic.auto.*
import io.circe.syntax.*
import org.virtuslab.yaml.*

import java.nio.file.{ Files, Paths }

def mainParams(): IO[Unit] =

   import DI.*
   val run =
     Injector[IO]().produceRun(configModule):
          (images: ImagesConfig) => {

            val outPath = "out"
            val conf = Configuration(
              cidr = "192.168.0",
              startPort = 10000,
              cassandra =
                List(
                  CassandraConfig(
                    host = "cassandra1.dev.me",
                    volume = "cassandra1-data",
                    clusterName = "cassandra-akka-cluster"),
                  CassandraConfig(
                    host = "cassandra2.dev.me",
                    volume = "cassandra2-data",
                    clusterName = "cassandra-akka-cluster")).some,
              mariadb =
                List(
                  MariadbConfig(
                    host = "maria1.dev.me",
                    volume = "mariadb1-data"),
//          MariadbConfig(
//            host = "maria2.dev.me",
//            volume = "mariadb2-data"
//          ),
                ).some,
              redpanda =
                List(
                  RedpandaConfig(
                    host = "redpanda1.dev.me",
                    volume = "redpanda1-data"),
//          RedpandaConfig(
//            host = "redpanda2.dev.me",
//            volume = "redpanda2-data"
//          ),
                ).some,
              jaeger =
                List(
                  JaegerConfig(
                    host = "jaeger1.dev.me",
                    command = "jaeger --config config.yaml",
                    working_dir = "wdir/jaeger"),
//          JaegerConfig(
//            host = "jaeger2.dev.me",
//            command = "jaeger --config config.yaml",
//            working_dir = "wdir/jaeger2",
//          ),
                ).some,
              keycloak =
                List(
                  KeycloakConfig(
                    host = "keycloak1.dev.me",
                    command = "kc.sh start-dev",
                    working_dir = "wdir/keycloak"),
//          KeycloakConfig(
//            host = "keycloak2.dev.me",
//            command = "kc.sh start-dev",
//            working_dir = "wdir/keycloak2",
//          ),
                ).some,
              minio =
                List(
                  MinIOConfig(
                    host = "minio1.dev.me",
                    command = "minio server ./data",
                    working_dir = "wdir/minio"),
//          MinIOConfig(
//            host = "minio2.dev.me",
//            command = "minio server ./data",
//            working_dir = "wdir/minio2",
//          ),
                ).some,
              mongodb =
                List(
                  MongoDBConfig(
                    host = "mongodb1.dev.me",
                    command = """mongod --auth --config mongod.conf --configExpand "exec"""",
                    working_dir = "wdir/mongo"),
//          MongoDBConfig(
//            host = "mongodb2.dev.me",
//            command = """mongod --auth --config mongod.conf --configExpand "exec"""",
//            working_dir = "wdir/mongo2",
//          ),
                ).some,
              nats =
                List(
                  NatsConfig(
                    host = "nats1.dev.me",
                    command = "nats-server -config server.conf",
                    working_dir = "wdir/nats"),
//          NatsConfig(
//            host = "nats2.dev.me",
//            command = "nats-server -config server.conf",
//            working_dir = "wdir/nats2",
//          ),
                ).some)
            val g = Generator(conf.startPort - 1, conf.cidr)
            val dcservices: List[(String, Option[List[services.Service]])] = List(
              (
                "jaeger",
                conf.jaeger.map {
                  _.zipWithIndex.map:
                       case (JaegerConfig(host, command, wdir), index) =>
                         services.Jaeger(
                           exporter_prometheus_port_config = 8888,
                           query_http_host_port_config = 16686,
                           query_grpc_host_port_config = 16685,
                           remote_sampling_http_port_config = 5778,
                           remote_sampling_grpc_port_config = 5779,
                           otlp_grpc_port_config = 4317,
                           otlp_http_port_config = 4318,
                           jaeger_protocols_grpc_port_config = 14250,
                           jaeger_protocols_thrift_http_port_config = 14268,
                           jaeger_protocols_thrift_binary_port_config = 6832,
                           jaeger_protocols_thrift_compact_port_config = 6831,
                           zipkin_port_config = 9411,
                           host = host,
                           command = command,
                           working_dir = wdir,
                           name = f"jaeger-${index + 1}")

                }),
              (
                "mariadb",
                conf.mariadb.map:
                     _.zipWithIndex.map:
                          case (MariadbConfig(host, vol), index) =>
                            services.Mariadb(
                              portConfig = 3306,
                              dataVolume = vol,
                              host = host,
                              name = f"mariadb-${index + 1}",
                              image = images.mariadb)

              ),
              (
                "cassandra",
                conf.cassandra.map:
                     _.zipWithIndex.map:
                          case (CassandraConfig(host, vol, clusterName), index) =>
                            services.Cassandra(
                              portConfig = 9042,
                              dataVolume = vol,
                              host = host,
                              name = f"cassandra-${index + 1}",
                              image = images.cassandra,
                              clusterName = clusterName)

              ),
              (
                "redpanda",
                conf.redpanda.map {
                  _.zipWithIndex.map:
                       case (RedpandaConfig(host, vol), index) =>
                         services.Redpanda(
                           schemaRegistryPortConfig = 18081,
                           pandaProxyPortConfig = 18082,
                           portConfig = 19092,
                           adminApiPortConfig = 9644,
                           consolePortConfig = 8080,
                           dataVolume = vol,
                           host = host,
                           name = f"redpanda-${index + 1}",
                           image = images.redpanda,
                           consoleImage = images.redpanda_console)

                }),
              (
                "keycloak",
                conf.keycloak.map {
                  _.zipWithIndex.map:
                       case (KeycloakConfig(host, command, wdir), index) =>
                         services.Keycloak(
                           portConfig = 8087,
                           host = host,
                           command = command,
                           working_dir = wdir,
                           name = f"keycloak-${index + 1}")

                }),
              (
                "minio",
                conf.minio.map {
                  _.zipWithIndex.map:
                       case (MinIOConfig(host, command, wdir), index) =>
                         services.MinIO(
                           portConfig = 9011,
                           consolePortConfig = 9012,
                           host = host,
                           command = command,
                           working_dir = wdir,
                           name = f"minio-${index + 1}")

                }),
              (
                "mongodb",
                conf.mongodb.map {
                  _.zipWithIndex.map:
                       case (MongoDBConfig(host, command, wdir), index) =>
                         services.MongoDB(
                           portConfig = 27017,
                           host = host,
                           command = command,
                           working_dir = wdir,
                           name = f"mongodb-${index + 1}")

                }),
              (
                "nats",
                conf.nats.map {
                  _.zipWithIndex.map:
                       case (NatsConfig(host, command, wdir), index) =>
                         services.Nats(
                           portConfig = 14222,
                           host = host,
                           command = command,
                           working_dir = wdir,
                           name = f"nats-${index + 1}")

                }))

            val dcsf: List[services.Service] = dcservices.map(_._2).flatten.flatten

            dcsf.foldLeft((g.ports, g.ips)):
                 case ((ports: LazyList[Int], ips: LazyList[DummyData]), s: services.Service) =>
                   val (a, b) = ports.splitAt(s.portsCount)
                   s.setPorts(a*)
                   s.network = ips.head.some
                   (b, ips.tail)

            val haproxy = dcsf.map(_.toHAproxy).mkString("\n")
            val dnsmasq = dcsf.map(_.toDNSMasq).mkString("\n") + "\n"
            val mappingsL = dcsf.map(_.genMappings)
            val networks = dcsf.map(_.network).flatten.asYaml

            val dnsmasqOrigin = new String(Files.readAllBytes(Paths.get("dnsmasq-head.conf")))
            val haproxyOrigin = new String(Files.readAllBytes(Paths.get("haproxy-head.cfg")))

            Files.write(Paths.get(f"out/dnsmask.conf"), (dnsmasqOrigin + dnsmasq).getBytes)
            Files.write(Paths.get(f"out/haproxy.cfg"), (haproxyOrigin + haproxy).getBytes)
            val json = mappingsL.asJson.noSpaces
            Files.write(Paths.get(f"out/mappings.json"), json.getBytes)
            Files.write(Paths.get(f"out/networks.yaml"), networks.getBytes)

            dcservices.foreach(
              (n, ss) => {
                ss.foreach {
                  _.zipWithIndex.foreach(
                    (s, i) => {
                      val entry = s.toYaml
                      Files.write(Paths.get(f"out/$n/$n-${i + 1}.yaml"), entry.getBytes)
                    })
                }
              })

            IO { () }
          }
   run
