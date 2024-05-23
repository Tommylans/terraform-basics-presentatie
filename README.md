# Presentatie over de basics van Terraform

Dit project is een presentatie over de basisprincipes van Terraform, gericht op het demonstreren van het gebruik van Terraform voor het beheren van cloudinfrastructuur. Het bevat voorbeelden van Terraform-configuraties voor het opzetten van een nginx-server op DigitalOcean, het beheren van DNS-instellingen via Cloudflare, en het gebruik van Terraform om resources zoals load balancers en domeinrecords te beheren.

## Presentatie

Om de presentatie te starten:
- `yarn install`
- `yarn run dev`
- ga naar http://localhost:3030

De slides zijn te vinden in de slides.md file. 

## Terraform

In de deployment folder staat een voorbeeld terraform configuratie om een nginx server te deployen.

Benodigdheden:
- [Terraform](https://www.terraform.io/downloads)
- [Digitalocean API token](https://www.digitalocean.com/docs/api/create-personal-access-token/)
- [Cloudflare API token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
    - Ook een domein waarop je wilt deployen

### Om de voorbeeld terraform configuratie te deployen:

```sh
# Ga naar de deployment folder
cd deployment

# Initializeert de terraform configuratie
terraform init

# Kijk wat er wordt gecreëerd
terraform plan

# Creëert de resources
terraform apply
```

