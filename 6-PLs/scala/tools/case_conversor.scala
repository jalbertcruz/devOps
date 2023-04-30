#!/usr/bin/env -S scala-cli shebang -S 3

//> using scala 3.6.2
//> using dep com.google.guava:guava:32.1.2-jre
//> using dep com.monovore::decline::2.4.1

import com.google.common.base.CaseFormat
import com.monovore.decline.*
import cats.implicits.*

val inputStringOpt = Opts.option[String]("input", short = "i", metavar = "inputString", help = "The string to convert.")
val caseFormatOpt = Opts.option[String]("format", short = "f", metavar = "caseFormat", help = "The target case format (e.g., LOWER_CAMEL, UPPER_UNDERSCORE).")

val appOptions = (inputStringOpt, caseFormatOpt).mapN { (input, format) =>
  (input, format)
}

val appCommand = Command(
  name = "convert-case",
  header = "Converts a string to the specified case format using Guava's CaseFormat."
) {
  appOptions
}
def getCaseFormat(input: String): CaseFormat = {
  if (input.contains("_")) {
    if (input == input.toUpperCase) {
      CaseFormat.UPPER_UNDERSCORE
    } else {
      CaseFormat.LOWER_UNDERSCORE
    }
  } else if (input.contains("-")) {
    CaseFormat.LOWER_HYPHEN
  } else if (Character.isUpperCase(input.charAt(0))) {
    if (input.exists(_.isLower)) {
      CaseFormat.UPPER_CAMEL
    } else {
      CaseFormat.UPPER_UNDERSCORE // Assuming no underscores but all uppercase
    }
  } else {
    CaseFormat.LOWER_CAMEL
  }
}
@main
def main(args: String*) = appCommand.parse(args, sys.env) match
  case Left(errors) =>
    System.err.println(errors)
    sys.exit(1)

  case Right((inputString, caseFormat)) =>
    val targetFormat = caseFormat match
      case "LOWER_CAMEL" => CaseFormat.LOWER_CAMEL
      case "UPPER_CAMEL" => CaseFormat.UPPER_CAMEL
      case "LOWER_UNDERSCORE" => CaseFormat.LOWER_UNDERSCORE
      case "UPPER_UNDERSCORE" => CaseFormat.UPPER_UNDERSCORE
      case "LOWER_HYPHEN" => CaseFormat.LOWER_HYPHEN
      case _ =>
        System.err.println(s"Unknown case format: $caseFormat")
        sys.exit(1)

    val inputFormat = getCaseFormat(inputString)
    val convertedString = inputFormat.to(targetFormat, inputString)
    print(convertedString)

