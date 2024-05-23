variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "ams3"
}

variable "cf_token" {
  description = "Cloudflare API token"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "cf_zone" {
  description = "Cloudflare zone ID"
  type        = string
  nullable    = false
}

variable "domain" {
  description = "Domain name"
  type        = string
  nullable    = false
}

variable "subdomain" {
  description = "Subdomain name"
  type        = string
  nullable    = false
}