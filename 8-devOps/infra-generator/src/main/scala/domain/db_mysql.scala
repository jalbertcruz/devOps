package domain

import cats.*, cats.implicits.*
import doobie.*
import doobie.implicits.*
import cats.effect.*

// This is just for testing. Consider using cats.effect.IOApp instead of calling
// unsafe methods directly.
import cats.effect.unsafe.implicits.global

//@main
def mysql(): Unit =
   // https://typelevel.org/doobie/docs/03-Connecting.html
   // A transactor that gets connections from java.sql.DriverManager and executes blocking operations
   // on an our synchronous EC. See the chapter on connection handling for more info.
//  val host="maria1.dev.me"
//  val port="3306"
   val host = "localhost"
   val port = "10024"
   val xa = Transactor.fromDriverManager[IO](
     driver = "com.mysql.cj.jdbc.Driver", // JDBC driver classname
     url = f"jdbc:mysql://$host:$port/service1", // ?user=app-user&password=dpass", // Connect URL
     user = "app-user", // Database user name
     password = "dpass", // Database password
     logHandler = None, // Don't setup logging for now. See Logging page for how to log events in detail
   )
   val program1 = 42.pure[ConnectionIO]
   val io = program1.transact(xa)
   // io: IO[Int] = Uncancelable(
   //   body = cats.effect.IO$$$Lambda$20284/0x000000080517a040@6f52a0ee,
   //   event = cats.effect.tracing.TracingEvent$StackTrace
   // )
//  println(io.unsafeRunSync())
   sql"select a from a"
     .query[String] // Query0[String]
     .to[List] // ConnectionIO[List[String]]
     .transact(xa) // IO[List[String]]
     .unsafeRunSync() // List[String]
     .take(1) // List[String]
     .foreach(println) // Unit
