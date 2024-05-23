# NOTE: Normaal splits je dit bestand wat meer op maar aangezien het een demo is heb ik het allemaal in 1 bestand gezet zodat je wat meer de connecties kan zien

provider "digitalocean" {
  token = var.do_token
}

provider "cloudflare" {
  api_token = var.cf_token
}


# Maakt een VM aan met nginx
resource "digitalocean_droplet" "presentation" {
  image = "nginx"
  name  = "presentatie"
  size  = "s-1vcpu-1gb"

  region = var.region
}

# Zorgt voor een firewall voor de aangemaakte VM zodat alleen de loadbalancer toegang heeft
resource "digitalocean_firewall" "presentatie_firewall" {
  name = "block-all"

  inbound_rule {
    protocol = "tcp"
    port_range = "80"

    # Wijst naar de resource id van de loadbalancer
    source_load_balancer_uids = [digitalocean_loadbalancer.presentation_loadbalancer.id]
  }


  # Standaard rules voor de firewall zorgt ervoor dat de VM ook nog toegang heeft tot internet
  outbound_rule {
    protocol = "icmp"
  }
  outbound_rule {
    protocol   = "tcp"
    port_range = "1-65535"
  }
  outbound_rule {
    protocol   = "udp"
    port_range = "1-65535"
  }

  # Zorgt ervoor dat de droplet aan de firewall is gekoppeld
  droplet_ids = [digitalocean_droplet.presentation.id]
}

resource "cloudflare_record" "presentation_ns_record" {
  # Maakt NS records aan voor de subdomain vanuit digitalocean 
  for_each = toset(["ns1", "ns2", "ns3"])

  zone_id = var.cf_zone
  proxied = false

  name  = var.subdomain
  type  = "NS"
  ttl   = 60
  value = "${each.key}.digitalocean.com"
}

resource "digitalocean_domain" "presentatie_domain" {
  name = "${var.subdomain}.${var.domain}"

  depends_on = [cloudflare_record.presentation_ns_record["ns1"]]
  # Laten we in iedergeval wachten tot de eerste NS record is aangemaakt in cloudflare
}

resource "digitalocean_certificate" "presentatie_domain_certificate" {
  type = "lets_encrypt"
  name = "presentation-certificate"

  domains = [digitalocean_domain.presentatie_domain.name]
}

resource "digitalocean_loadbalancer" "presentation_loadbalancer" {
  name   = "presentation-loadbalancer"
  region = var.region

  enable_proxy_protocol = false

  redirect_http_to_https = true

  disable_lets_encrypt_dns_records = true

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  forwarding_rule {
    # Zorgt ervoor dat de response van de loadbalancer de certificaat gebruikt van de domain
    certificate_name = digitalocean_certificate.presentatie_domain_certificate.name

    entry_port      = 443
    entry_protocol  = "https"
    target_port     = 80
    target_protocol = "http"
  }

  # De loadbalancer word aan de droplet gekoppeld (normaal zijn het er meerdere)
  droplet_ids = [digitalocean_droplet.presentation.id]
}


# Maakt de uiteindelijke domein aan die verwijst naar de loadbalancer en die ook door de gebruikers wordt gebruikt
resource "digitalocean_record" "presentatie_record" {
  domain = digitalocean_domain.presentatie_domain.name
  name   = "@"
  type   = "A"
  value  = digitalocean_loadbalancer.presentation_loadbalancer.ip
  ttl    = 60
}