variable "base-image" {
  type    = string
}

variable "docker-tag" {
  type    = string
}

variable "erlang-version" {
  type    = string
}

variable "erts-version" {
  type    = string
}

variable "elixir-version" {
  type    = string
}

variable "kerl-configure-options" {
  type    = string
  default = ""
}

variable "default-erlang-configure-options" {
  type    = string
  default = ""
}

source "docker" "resource_1" {
  changes = [
    "USER root",
    "ENV PATH \"$PATH:/usr/bin\"",
    "ENTRYPOINT /home/app/entrypoint.sh",
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
    ansible_env_vars = [
      "ERLANG_VERSION=${var.erlang-version}",
      "ERTS_VERSION=${var.erts-version}",
      "ELIXIR_VERSION=${var.elixir-version}",
      "KERL_CONFIGURE_OPTIONS=${var.kerl-configure-options}",
      "DEFAULT_ERLANG_CONFIGURE_OPTIONS=${var.default-erlang-configure-options}"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "docker.io/jalbert/elixir"
      tags = [var.docker-tag]
    }
    post-processor "docker-push" {
    }
  }
}
