# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "docker" "docker_source" {
  changes = ["ENTRYPOINT [\"/init\"]", "EXPOSE 22 24224 5140", "ENV NOTVISIBLE \"in users profile\""]
  commit  = true
  image   = "jalbert/ubuntu:20.04"
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.docker.docker_source"]

  provisioner "ansible" {
    playbook_file = "provision.yml"
    user          = "root"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "docker.io/jalbert/fluentd"
      tags        = ["calyptia"]
    }
    post-processor "docker-push" {
    }
  }
}
