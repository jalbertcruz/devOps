
variable "dockerhub_username" {
  type = string
}

variable "dockerhub_password" {
  type = string
}

source "docker" "docker_resource" {
  changes = [
    "USER root",
    "ENV PATH \"$PATH:/usr/lib/protoc/bin:/usr/lib/sbt/bin:/usr/bin\"",
    "WORKDIR /src"
  ]
  commit = true
  image = "eclipse-temurin:17.0.7_7-jdk"
}

build {
  sources = [
    "source.docker.docker_resource"]

  provisioner "ansible" {
    playbook_file    = "provision.yml"
    user             = "root"
    extra_arguments  = ["-vvvv", "--ssh-extra-args", "-o IdentitiesOnly=yes -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa"] # Make ansible and ssh client very verbose
    ansible_env_vars = [
      "ANSIBLE_PIPELINING=true",
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "docker.io/jalbert/scala"
      tags = ["sbt-1.9"]
    }
    post-processor "docker-push" {
      login = true
      login_username = var.dockerhub_username
      login_password = var.dockerhub_password
    }
  }
}
