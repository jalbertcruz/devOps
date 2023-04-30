
variable "dockerhub_username" {
  type = string
}

variable "dockerhub_password" {
  type = string
}

source "docker" "docker-source" {
  changes = [
    "ENTRYPOINT [\"/init\"]",
#    "EXPOSE 22",
#    "ENV NOTVISIBLE \"in users profile\""
  ]
  commit  = true
#  image   = "ubuntu:20.04"
  image   = "ubuntu:22.04"
}

build {
  sources = ["source.docker.docker-source"]

  provisioner "ansible" {
    ansible_env_vars = [
      "ANSIBLE_DISTRIBUTION=debian",
      "ANSIBLE_PIPELINING=true",
    ]
    extra_arguments  = ["-vvvv", "--ssh-extra-args", "-o IdentitiesOnly=yes -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa"] # Make ansible and ssh client very verbose
    playbook_file    = "provision.yml"
    user             = "root"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "docker.io/jalbert/ubuntu-basic"
#      tags        = ["20.04"]
      tags        = ["22.04"]
      force = true
    }
  }
}

packer {
  required_plugins {
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
    docker = {
      source  = "github.com/hashicorp/docker"
      version = "~> 1"
    }
  }
}
