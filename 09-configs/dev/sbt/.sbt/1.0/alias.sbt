
lazy val cleanLocalIvy = taskKey[Unit]("Clean local Ivy2 folder")
cleanLocalIvy := {
  import scala.sys.process._
  val s: TaskStreams = streams.value
  val shell: Seq[String] =
    if (sys.props("os.name").contains("Windows"))
      Seq("cmd", "/c")
    else
      Seq("bash", "-c")
//  val clean: Seq[String] = shell :+ f"rm -Rf ${smithyFilesPath.value} || true"
  val clean: Seq[String] = shell :+ "rm -Rf $HOME/.ivy2/local || true"
  s.log.info("Removing Ivy2 folder...")
  if ((clean !) == 0) {
    s.log.success("Ivy2 folder removed!")

  } else
    throw new IllegalStateException("Error deleting the Ivy2 folder!")
}

addCommandAlias("ll", "projects")
addCommandAlias("cd", "project")
addCommandAlias("c", "compile")
addCommandAlias("cc", "clean; compile")
addCommandAlias("cs", "console")
addCommandAlias("dp", "cleanLocalIvy; publishLocal")
addCommandAlias("t", "test")
addCommandAlias("r", "run")
addCommandAlias("styleCheck", "scalafmtSbtCheck; scalafmtCheckAll")
addCommandAlias("stf", "scalafmtSbt; scalafmtAll")
addCommandAlias("styleFix", "scalafmtSbt; scalafmtAll; scalafix RemoveUnused; scalafix OrganizeImports")
addCommandAlias("rl", "reload plugins; update; reload return")
