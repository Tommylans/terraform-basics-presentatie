variable "do_token" {
  description = "DigitalOcean API token"
  nullable = false
  sensitive = true
}

variable "region" {
  description = "DigitalOcean region"
  default = "ams3"
}

variable "cf_token" {
  description = "Cloudflare API token"
  nullable = false
  sensitive = true
}

variable "cf_zone" {
  description = "Cloudflare zone ID"
  nullable = false
}

variable "domain" {
    description = "Domain name"
    nullable = false
}

variable "subdomain" {
    description = "Subdomain name"
    nullable = false
}