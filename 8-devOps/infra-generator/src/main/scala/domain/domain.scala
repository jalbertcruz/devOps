package domain

import scala.util.chaining.*

extension [A](a: A)
   def |>[B](f: (A) => B): B = f(a)
   def |[B](f:  (A) => B): B = a.pipe(f)

import com.github.slugify.Slugify

extension (a: String)
   def nullRemoved = a.split("\n").filter(!_.contains("!!null")).mkString("\n")

   def slugify =
      val slg = Slugify.builder().underscoreSeparator(true).build()
      slg.slugify(a)
