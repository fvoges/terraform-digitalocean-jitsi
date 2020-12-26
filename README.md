# terraform-jitsi

## Overview

This Terraform code will:

- Manage a [DigitalOcean](https://m.do.co/c/bb184ec400b6) (referral link) Droplet
  - Add all available [SSH keys in DigitalOcean account](https://cloud.digitalocean.com/account/security) to the Droplet
  - Assign the following tags to the Droplet
    - `all`
    - `http`
    - `https`
    - `jitsi`
- Install [Puppet Agent](https://puppet.com) in
  - Pass data to the Agent to configure the following Trusted Facts
    - `pp_application` (default: `conference`)
    - `pp_role` (default: `server`)
    - `pp_environment` (default: `production`)
    - `pp_datacenter` (using the droplet region value)
  - Pass an auto-sign token to the Puppet Agent installer
- Manage A and AAAA DNS records for the Droplets using DigitalOcean's DNS
- Manage a DigitalOcean Project (default name: `jitsi`)

The code doesn't manage the DNS domain name, nor DigitalOcean firewall rules.

I use these DigitalOcean tags for the firewall rules:

- `all` does the basic firewall rules (deny all, allows ping, allows SSH from certain IPs/subnets)
- `http` Allows inbound TCP/80
- `https` Allows inbound TCP/443
- `jitsi` The other ports [listed here](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-quickstart#setup-and-configure-your-firewall)

## Jitsi installation

The actual installation is done by Puppet.

## Inputs

I recommend using [Terraform Cloud](https://app.terraform.io/) and to configure the variables there.

See [`variables.tf`](variables.tf).

You'll also have to specify the [DigitalOcean API Token](https://cloud.digitalocean.com/account/api/tokens). Just add `DIGITALOCEAN_TOKEN` as a sensitive environment variable in the workspace configuration.

## Outputs

On completion, the code will show the URL to the provisioned server.
