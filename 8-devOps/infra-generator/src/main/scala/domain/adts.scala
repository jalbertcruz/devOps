package domain

package adts

import org.virtuslab.yaml.*

case class ServiceBody(
  image:          String,
  profiles:       Seq[String],
  container_name: String,
  hostname:       String,
  restart:        String,
  ports:          Seq[String],
  networks:       Seq[String],
  volumes:        Option[Seq[String]] = None,
  command:        Option[Seq[String]] = None,
  depends_on:     Option[Seq[String]] = None,
  labels:         Option[Seq[String]] = None,
  entrypoint:     Option[String] = None,
  environment:    Option[Map[String, String]] = None) derives YamlCodec

case class ServiceBody2(
  image:          String,
  profiles:       Seq[String],
  container_name: String,
  hostname:       String,
  restart:        String,
  ports:          Seq[String],
  networks:       Seq[String],
  volumes:        Option[Seq[String]] = None,
  command:        Option[String] = None,
  depends_on:     Option[Seq[String]] = None,
  labels:         Option[Seq[String]] = None,
  entrypoint:     Option[String] = None,
  environment:    Option[Map[String, String]] = None) derives YamlCodec

case class ProcessComposeBody(
  command:     String,
  working_dir: String,
  environment: Option[List[String]] = None) derives YamlCodec

case class MariadbConfig(
  host:   String,
  volume: String) derives YamlCodec

case class PostgresConfig(
  host:   String,
  volume: String) derives YamlCodec

case class CassandraConfig(
  host:        String,
  volume:      String,
  clusterName: String) derives YamlCodec

case class RedpandaConfig(
  host:   String,
  volume: String) derives YamlCodec

case class JaegerConfig(
  host:        String,
  command:     String,
  working_dir: String) derives YamlCodec

case class MongoDBConfig(
  host:        String,
  command:     String,
  working_dir: String) derives YamlCodec

case class MinIOConfig(
  host:        String,
  command:     String,
  working_dir: String) derives YamlCodec

case class KeycloakConfig(
  host:        String,
  command:     String,
  working_dir: String) derives YamlCodec

case class NatsConfig(
  host:        String,
  command:     String,
  working_dir: String) derives YamlCodec

case class Configuration(
  cidr:      String,
  startPort: Int,
  mariadb:   Option[List[MariadbConfig]] = None,
  redpanda:  Option[List[RedpandaConfig]],
  jaeger:    Option[List[JaegerConfig]] = None,
  keycloak:  Option[List[KeycloakConfig]] = None,
  minio:     Option[List[MinIOConfig]] = None,
  mongodb:   Option[List[MongoDBConfig]] = None,
  nats:      Option[List[NatsConfig]] = None,
  cassandra: Option[List[CassandraConfig]] = None) derives YamlCodec

case class ConfigurationTraefik(postgres: Option[List[PostgresConfig]] = None) derives YamlCodec

case class DummyData(
  name: String,
  ip:   String,
  id:   Int) derives YamlCodec

case class PortMap(
  fix:      Int,
  variable: Int) derives YamlCodec

case class Mappings(
  host:  String,
  ports: List[PortMap]) derives YamlCodec

case class Images(images: List[String]) derives YamlCodec
