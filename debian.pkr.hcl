packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/digitalocean"
    }
  }
}

variable digitalocean_token {
  type = string
}

locals {
  region = "fra1"
  size   = "s-1vcpu-1gb"
  image  = "debian-11-x64"
  snapshot_regions = [
    "nyc1",
    "nyc2",
    "nyc3",
    "sfo1",
    "sfo2",
    "sfo3",
    "ams2",
    "ams3",
    "sgp1",
    "lon1",
    "fra1",
    "tor1",
    "blr1",
  ]
}

variable install_glusterfs {
  type    = bool
  default = false
}

variable install_docker {
  type    = bool
  default = false
}

source digitalocean debian {
  snapshot_name    = "debian${var.install_glusterfs == true ? "+glusterfs" : ""}${var.install_docker == true ? "+docker" : ""}-{{isotime}}"
  snapshot_regions = local.snapshot_regions
  region           = local.region
  size             = local.size
  image            = local.image
  ssh_username     = "root"
  api_token        = var.digitalocean_token
  monitoring       = true
}

build {
  sources = [
    "source.digitalocean.debian"
  ]
  provisioner ansible {
    playbook_file = "playbook/_all.yml"
    extra_arguments = [
      "--extra-vars",
      "install_glusterfs=${var.install_glusterfs} install_docker=${var.install_docker}"
    ]
  }
}
