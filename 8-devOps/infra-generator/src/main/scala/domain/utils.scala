package domain
package logic

import adts.*

import scala.annotation.tailrec

import java.net.ServerSocket
import scala.math.BigInt

import distage.config.{ AppConfig, ConfigModuleDef }
import com.typesafe.config.ConfigFactory
import Configs.*

@tailrec
def nextFreePort(port: Int): Int =
   val nextPort = port + 1
   try
      val socket = new ServerSocket(nextPort)
      socket.close()
      nextPort
   catch
      case _: Exception => nextFreePort(nextPort)

class Generator(startPort: Int, cidr: String):

   val fibs: LazyList[BigInt] =
     BigInt(0) #:: BigInt(1) #:: fibs.zip(fibs.tail).map:
          n => n._1 + n._2

   val ports: LazyList[Int] =
      val f = nextFreePort(startPort)
      val s = nextFreePort(f)
      f #:: s #:: ports.tail.map:
           n => nextFreePort(n)

   val ips: LazyList[DummyData] =
      val id1 = 1
      val f = DummyData(name = f"dummy$id1", ip = f"${cidr}.${id1}/24", id = id1)
      val s = DummyData(name = f"dummy${f.id + 1}", ip = f"${cidr}.${f.id + 1}/24", id = f.id + 1)
      f #:: s #:: ips.tail.map:
           n => DummyData(name = f"dummy${n.id + 1}", ip = f"${cidr}.${n.id + 1}/24", id = n.id + 1)

object DI:

   val configModule =
     new ConfigModuleDef:
        makeConfig[ImagesConfig]("images")
        make[AppConfig].from(AppConfig.provided(
          ConfigFactory
            .defaultApplication().getConfig("app").resolve()))
