
variable "dockerhub_username" {
  type = string
}

variable "dockerhub_password" {
  type = string
}

source "docker" "docker_resource" {
  changes = [
    "USER root",
    "WORKDIR /workdir",
#     "ENTRYPOINT [\"/usr/bin/hugo\"]",
  ]
  commit = true
  image = "jalbert/ruby:3.3.4"
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
      repository = "docker.io/jalbert/hugo"
      tags = ["129"]
    }
    post-processor "docker-push" {
      login = true
      login_username = var.dockerhub_username
      login_password = var.dockerhub_password
    }
  }
}
