---
theme: seriph
background: https://cover.sli.dev?1
title: Terraform presentatie
info: |
  ## Presentatie over de basics van Terraform
class: text-center
# https://sli.dev/custom/highlighters.html
highlighter: shiki
# https://sli.dev/guide/drawing
drawings:
  persist: false
# slide transition: https://sli.dev/guide/animations#slide-transitions
transition: slide-left
# enable MDC Syntax: https://sli.dev/guide/syntax#mdc-syntax
mdc: true
---

# Terraform presentatie

Basics van Terraform

<br>

Tom Lanser - 24 mei 2024

---

# Onderwerpen

<Toc />

---

# Wat is Terraform?

Terraform is een open-source tool waarmee je cloud infrastructuur kan beheren.


Onderdelen van Terraform:

- 🔌 **Provider** - Een plugin die Terraform gebruikt om te communiceren met een cloud provider.
- 🛠️ **Resource** - Een object binnen de cloud provider dat beheerd wordt.
- 📝 **Variable** - Variables kunnen worden gebruikt om waarden configureerbaar te maken.
- 📤 **Output** - Outputs geven informatie over de resources na het toepassen van Terraform configuraties.
- 📊 **State** - De huidige status van de beheerde resources.
- ⌨️ **CLI** - De command line interface voor interactie met Terraform.


<!--
  **Provider** - Kan bijvoorbeeld AWS, Google, Azure, etc. zijn
  **Resource** - Een resource is bijv. een virtuele machine in AWS
  **State** - Het huidige status van de collectie resources
  **CLI** - De command line interface die je kan gebruiken om Terraform te gebruiken
-->

---
level: 2
---

# Variable
Variables kunnen worden gebruikt om waarden configureerbaar te maken.

````md magic-move
```hcl
variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "ams3"
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  nullable    = false
}
```
```hcl
variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "ams3"
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  nullable    = false
  sensitive   = true
}
```

````

---
layout: image-right
image: https://cover.sli.dev?2
level: 2
---

# Provider

Voorbeeld provider van DigitalOcean

Hierin defineer je vooral de specificaties van de cloud provider om ermee te kunnen praten en resources te beheren

````md magic-move
```hcl
provider "digitalocean" {
  token = "geheim123"
}
```
```hcl
provider "digitalocean" {
  token = var.do_token
}
```
````

<!-- 
  [click] -> Je ziet nu eigenlijk dat de variables gewoon in de provider staan gewoon open en blood
  [click:2] -> We hebben bij de vorige slide meerdere variables gedefineerd die we dan ook gelijk kunnen gebruiken binnen dit stuk
-->

---
level: 2
---

# Resource

Hieronder een voorbeeld van hoe je DigitalOcean resources kunt definiëren met Terraform:

````md magic-move
```hcl
resource "digitalocean_droplet" "presentation" {
  image = "nginx"
  name  = "presentatie"
  size  = "s-1vcpu-1gb"

  region = var.region
}
```
```hcl
resource "digitalocean_domain" "presentatie_domain" {
  name = "${var.subdomain}.${var.domain}"
}

resource "digitalocean_certificate" "presentatie_domain_certificate" {
  type = "lets_encrypt"
  name = "presentation-certificate"

  domains = [digitalocean_domain.presentatie_domain.name]
}
```
```hcl
resource "cloudflare_record" "presentation_ns_record" {
  for_each = toset(["ns1", "ns2", "ns3"])

  zone_id = var.cf_zone
  proxied = false

  name  = var.subdomain
  type  = "NS"
  ttl   = 60
  value = "${each.key}.digitalocean.com"
}
```
````

---
layout: image-right
image: https://cover.sli.dev?4
level: 2
---

# State
Een state bestaat uit de huidige status van de beheerde resources.

Standaard staat de state opgeslagen op schijf, maar je kan deze ook op een S3 bucket bijhouden.

Dit bied de mogelijkheid om de state makkelijk te delen binnen de CD pipeline.

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "path/to/my/key"
  }
}
```

---
level: 2
---

# CLI
De cli kan je gebruiken om te werken met terraform.

De lifecylce van de cli:

1. `terraform init` -> Dit initialiseert de terraform cli met de provider en de state.
2. `terraform plan` -> Dit toont alle resources die worden gemaakt of gewijzigd.
3. `terraform apply` -> Dit maakt de resources aan op basis van wat er verschild tussen de state en de configuratie.
4. `terraform destroy` -> Dit verwijdert alle resources die worden gemaakt of gewijzigd.

---
layout: cover
image: https://cover.sli.dev?7
class: text-center
---

# Demo


---
layout: center
---

# Vragen?

<RepositoryQR />
