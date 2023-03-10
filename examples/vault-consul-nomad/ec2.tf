locals {
  vault-consul = templatefile(
    "${path.root}/../../../scripts/install-hashicorp.sh.tmpl",
    { packages : "vault consul" }
  )

  vault-consul-nomad = templatefile(
    "${path.root}/../../../scripts/install-hashicorp.sh.tmpl",
    { packages : "vault consul nomad" }
  )
}

resource "vultr_vpc" "vpc" {
  region = "waw"
}

//noinspection MissingModule
module "ec2" {
  source       = "nullc4t/ec2/vultr"
  version      = ">= 0.0.2"

  region       = "waw"
  ssh_key_name = "ecdsa"
  os_id        = 1743
  snapshot_id  = null
  vpc_ids      = []
  vm_instances = {
    vault = {
      plan           = "vc2-1c-1gb"
      count          = 1
      startup_script = local.vault-consul
    }
    consul = {
      plan           = "vc2-1c-1gb"
      count          = 1
      startup_script = local.vault-consul
    }
    nomad = {
      plan           = "vc2-1c-1gb"
      count          = 1
      startup_script = local.vault-consul-nomad
    }
    nomad-client = {
      plan           = "vc2-1c-1gb"
      count          = 1
      startup_script = <<EOF
${file("${path.root}/../../../scripts/install-docker.sh")}
${local.vault-consul-nomad}
EOF
    }
  }
}
