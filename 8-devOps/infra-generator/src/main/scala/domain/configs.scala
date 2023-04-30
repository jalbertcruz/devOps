package domain

object Configs:

   case class ImagesConfig(
     postgres_15:         String,
     postgres_16:         String,
     postgres_17:         String,
     postgres_18:         String,
     postgres_debian:  String,
     postgis:          String,
     mariadb:          String,
     mysql:            String,
     redpanda:         String,
     redpanda_console: String,
     cassandra:        String,
     latex:            String,
     registry:         String,
     dnsmasq:          String,
     traefik:          String,
     rabbitmq:         String,
     stirlingtools:   String,
     penpotapp_frontend:   String,
     penpotapp_backend:   String,
     penpotapp_exporter:   String,
     penpot_mailcatch: String,
     valkey:   String,

     )
