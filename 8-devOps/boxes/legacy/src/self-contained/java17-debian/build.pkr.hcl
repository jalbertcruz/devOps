source "docker" "docker_source" {
  changes = ["USER root", "WORKDIR /workdir"]
  commit  = true
  image   = "debian:bullseye-slim"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.docker.docker_source"]

  provisioner "ansible" {
    playbook_file = "provision-j17.yml"
    user          = "root"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "gitlab.betika.private:4567/platform-dev/libraries/jdk-oracle"
      tags       = ["17"]
    }
    post-processor "docker-push" {
    }
  }
}
