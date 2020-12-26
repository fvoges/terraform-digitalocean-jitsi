terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.3"
    }
  }
  backend "remote" {
    organization = "boats"

    workspaces {
      name = "jitsi"
    }
  }
}

provider "digitalocean" {}
