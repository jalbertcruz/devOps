package domain
package services

import domain.adts.Mappings
import domain.adts.DummyData

trait Service:

   var network: Option[DummyData]

   val portsCount: Int

   def setPorts(ports: Int*): Unit

   def toYaml: String

   def toHAproxy: String

   def toDNSMasq: String

   def genMappings: Mappings
