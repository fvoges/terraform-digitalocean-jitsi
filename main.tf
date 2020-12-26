resource "digitalocean_project" "jitsi" {
  name        = var.project_name
  description = "A project to represent development resources."
  purpose     = "Web Conference"
  environment = var.environment
}

data "digitalocean_ssh_keys" "all" {
}

locals {
  userdata_vars = {
    hostname       = var.hostname
    fqdn           = "${var.hostname}.${var.domain}"
    datacenter     = var.region
    application    = var.application
    role           = var.role
    environment    = var.environment
    puppet_server  = var.puppet_server
    autosign_token = var.autosign_token
  }
}

resource "digitalocean_droplet" "jitsi" {
  image    = var.image
  name     = "${var.hostname}.${var.domain}"
  region   = var.region
  size     = var.size
  ipv6     = true
  tags     = [ "jitsi", "all", "https", "http", ]
  ssh_keys = data.digitalocean_ssh_keys.all.ssh_keys.*.fingerprint
  user_data = templatefile("${path.module}/templates/userdata.tpl", local.userdata_vars)

}

resource "digitalocean_record" "jitsi4" {
  domain = var.domain
  type   = "A"
  name   = var.hostname
  value  = digitalocean_droplet.jitsi.ipv4_address
}

resource "digitalocean_record" "jitsi6" {
  domain = var.domain
  type   = "AAAA"
  name   = var.hostname
  value  = digitalocean_droplet.jitsi.ipv6_address
}

resource "digitalocean_project_resources" "jitsi" {
  project = digitalocean_project.jitsi.id

  resources = [
    digitalocean_droplet.jitsi.urn,
  ]
}