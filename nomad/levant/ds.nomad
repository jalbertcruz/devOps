job "[[ $.job.name ]]" {

  region = "global"

  datacenters = [
    "dc1"]

  namespace = "default"

  type = "service"

  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "server" {

    network {

[[ range $varName := keys $.job.network ]]
[[ with $varValue := get $.job.network $varName ]]

[[ range $varName2 := keys $varValue ]]
port "[[ $varName ]]" {
[[ with $varValue2 := get $varValue $varName2 ]]
 [[ $varName2 ]] = [[ $varValue2 ]]
[[ end ]]
}

[[ end ]]

[[ end ]]
[[ end ]]

    }


    task "task-[[ $.job.name ]]" {
      driver = "docker"

      [[ if $.job.task.env ]]
      env {
[[ range $varName := keys $.job.task.env ]]
[[ with $varValue := get $.job.task.env $varName ]]
[[ $varName ]] = "[[ $varValue ]]"[[ end ]]
[[ end ]]
}
      [[ end ]]

      constraint {
        attribute = "${attr.kernel.name}"
        value = "linux"
      }

      config {
        image = "[[ $.job.task.config.image ]]"

        [[ if $.job.task.config.command ]]
        command = "[[ $.job.task.config.command ]]"
        [[ end ]]

        args = [
              [[ range $arg := $.job.task.config.args ]] "[[ $arg ]]",[[ end ]]
               ]

        hostname = "[[ $.job.task.config.hostname ]]"

        ports = [

        [[ range $varName := keys $.job.network ]]
[[ with $varValue := get $.job.network $varName ]]
 "[[ $varName ]]" , [[ end ]]
[[ end ]]

]

        tty = true

        volumes = [

[[ range $varName := keys $.job.task.config.volume ]]
[[ with $keyEntry := get $.job.task.config.volume $varName ]]
 "[[ consulKey (get $keyEntry "key") ]]:[[ get $keyEntry "path" ]]"     , [[ end ]]
[[ end ]]
        ]

      }

      service {
        name = "[[ $.job.name ]]"
        port = "[[ $.job.task.service.port ]]"
        address_mode = "driver"

        check {
          type = "tcp"
          port = "[[ $.job.task.service.port ]]"
          interval = "10s"
          timeout = "2s"
        }

      }

      resources {
        memory = [[ $.job.task.resource.memory ]]
        cpu = [[ $.job.task.resource.cpu ]]
      }

    }
  }
}
