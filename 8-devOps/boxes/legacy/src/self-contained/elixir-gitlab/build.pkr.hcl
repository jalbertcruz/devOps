variable "base-image" {
  type    = string
}

variable "docker-tag" {
  type    = string
}

source "docker" "resource_1" {
  changes = [
    "USER root",
    "ENV PATH \"$PATH:/usr/bin:$HOME/.local/bin:$HOME/.mix/escripts\"",
    "CMD [\"iex\"]",
  ]
  commit = true
  image = var.base-image
}

build {
  sources = [
    "source.docker.resource_1"]

  provisioner "ansible" {
    playbook_file = "provision.yml"
    user = "root"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "docker.io/jalbert/elixir-gitlab"
      tags = [var.docker-tag]
    }
    post-processor "docker-push" {
    }
  }
}
