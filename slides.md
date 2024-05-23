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

<div class="flex justify-center">
  <img src="https://www.terraform.io/assets/images/logo-hashicorp-3f122f422f4.svg" alt="Terraform" width="200" height="200">
</div>

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

# Variable
Variables kunnen worden gebruikt om waarden configureerbaar te maken.

```hcl {*|10|*}
variable "region" {
  description = "The region where AWS resources will be created"
  type        = string
  default     = "eu-central-1"
}

variable "secret_key" {
  description = "The secret key for AWS"
  type        = string
  sensitive   = true
}
```

---
layout: image-right
image: https://cover.sli.dev?2
---

# Provider

Voorbeeld provider van AWS

Hierin defineer je vooral de specificaties van de cloud provider om ermee te kunnen praten en resources te beheren

````md magic-move
```hcl {*|2-4|*}
provider "aws" {
  region = "eu-central-1"
  access_key = "geheim123"
  secret_key = "geheim123"
  version = "~> 3.0"
}
```
```hcl
provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  version = "~> 3.0"
}
```
````

<!-- 
  [click] -> Je ziet nu eigenlijk dat de variables gewoon in de provider staan gewoon open en blood
  [click:2] -> We hebben bij de vorige slide meerdere variables gedefineerd die we dan ook gelijk kunnen gebruiken binnen dit stuk
-->

---
layout: image-right
image: https://cover.sli.dev?3
---

# Resource

Hieronder een voorbeeld van hoe je een AWS EC2 instance kunt definiëren met Terraform:

```hcl
resource "aws_instance" "" {
  ami           = "ami-12345"
  instance_type = "t2.micro"
  key_name      = "my-key-pair"

  tags = {
    Name        = "backend"
    Environment = "development"
  }
}
```


---
layout: image-right
image: https://cover.sli.dev?4
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
    region = "eu-central-1"
  }
}
```

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
class: text-center
---

# Vragen?

