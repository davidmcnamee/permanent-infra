
resource "aws_route53_zone" "main" {
  name = "vidmcnam.ee"
}

resource "aws_route53_zone" "groupshot" {
  name = "groupshot.xyz"
}

resource "aws_route53_zone" "mcnamee_io" {
  name = "mcnamee.io"
}

output "dns_nameservers_vidmcnam_ee" { value = aws_route53_zone.main.name_servers }
output "dns_nameservers_mcnamee_io" { value = aws_route53_zone.mcnamee_io.name_servers }
output "dns_nameservers_groupshot" { value = aws_route53_zone.groupshot.name_servers }


resource "aws_route53_record" "mcnamee_io_mx" {
  zone_id = aws_route53_zone.mcnamee_io.zone_id
  name    = "mcnamee.io"
  type    = "MX"
  ttl     = "300"
  records = [
    "10 mx.zoho.com",
    "20 mx2.zoho.com",
    "50 mx3.zoho.com"
  ]
}

resource "aws_route53_record" "mcnamee_io_txt" {
  zone_id = aws_route53_zone.mcnamee_io.zone_id
  name    = "mcnamee.io"
  type    = "TXT"
  ttl     = "300"
  records = ["v=spf1 include:zoho.com ~all"]
}

resource "aws_route53_record" "mcnamee_io_dkim" {
  zone_id = aws_route53_zone.mcnamee_io.zone_id
  name    = "zmail._domainkey.mcnamee.io"
  type    = "TXT"
  ttl     = "300"
  records = [
    # must be split by \"\"    see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#records
    "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCpWhkiL9D8I/bG3F7Z6FnZ32pwjlovqbIcjtr0iDbnsE8YwcekKTSuE\"\"IS1SglOs38nBwODHcJlhh7/YNymtZeQ27cSJOan6ecmH0y28c/gGGvLA4/G6UnPalNNr0/FWwQ98KM8MPZqtBbI/2NBC7OcZ7/uJP608xXf9MGq4mSLhwIDAQAB"
  ]
}

# resource "aws_route53_record" "groupshot_a" {
#   zone_id = aws_route53_zone.groupshot.zone_id
#   name    = "groupshot.xyz"
#   type    = "A"
#   ttl     = "300"
#   records = [google_compute_global_address.external_ip.address]
# }

resource "aws_route53_record" "main_mx" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "vidmcnam.ee"
  type    = "MX"
  ttl     = "300"
  records = [
    "10 mx.zoho.com",
    "20 mx2.zoho.com",
    "50 mx3.zoho.com"
  ]
}

resource "aws_route53_record" "main_txt" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "vidmcnam.ee"
  type    = "TXT"
  ttl     = "300"
  records = [
    "zoho-verification=zb81039885.zmverify.zoho.com",
    "v=spf1 include:zoho.com ~all"
  ]
}

resource "aws_route53_record" "main_dkim" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "zmail._domainkey.vidmcnam.ee"
  type    = "TXT"
  ttl     = "300"
  records = [
    # must be split by \"\"    see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#records
    "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC0jkcioC9RwIwPBWxWvZRlNuSpqJHjizedkpCSszAkWu3wqJXBMK3A2GTRth\"\"9n9P+Qywu0MoB043gO9HNNP/cv+fKTkNux9rva4ru6Vet4+uYaWB8xPNyu5onkhBW8z11jBZIfEorAikv9RH8uu6joeSd2xW5cyVmu7lVhtPwO6wIDAQAB"
  ]
}

resource "aws_route53_record" "vercel_site" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "da.vidmcnam.ee"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "cname.vercel-dns.com"
  ]
}

# resource "aws_route53_record" "shopify_challenge" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "shopify.da.vidmcnam.ee"
#   type    = "A"
#   ttl     = "300"
#   records = [google_compute_global_address.external_ip.address]
# }

# resource "aws_route53_record" "shopify_challenge_frontend" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "meme-marketplace.da.vidmcnam.ee"
#   type    = "A"
#   ttl     = "300"
#   records = [google_compute_global_address.external_ip.address]
# }

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

# resource "tls_private_key" "private_key" {
#   algorithm = "RSA"
# }

# resource "acme_registration" "reg" {
#   account_key_pem = tls_private_key.private_key.private_key_pem
#   email_address   = "d@vidmcnam.ee"
# }

# resource "acme_certificate" "certificate" {
#   account_key_pem           = acme_registration.reg.account_key_pem
#   common_name               = "shopify.da.vidmcnam.ee"

#   dns_challenge {
#     provider = "route53"
#     config = {
#       AWS_HOSTED_ZONE_ID    = aws_route53_zone.main.zone_id
#     }
#   }
# }

# resource "acme_certificate" "certificate2" {
#   account_key_pem           = acme_registration.reg.account_key_pem
#   common_name               = "meme-marketplace.da.vidmcnam.ee"

#   dns_challenge {
#     provider = "route53"
#     config = {
#       AWS_HOSTED_ZONE_ID    = aws_route53_zone.main.zone_id
#     }
#   }
# }

# resource "acme_certificate" "groupshot_certificate" {
#   account_key_pem           = acme_registration.reg.account_key_pem
#   common_name               = "groupshot.xyz"

#   dns_challenge {
#     provider = "route53"
#     config = {
#       AWS_HOSTED_ZONE_ID    = aws_route53_zone.groupshot.zone_id
#     }
#   }
# }

# output "ssl_key" {
#   sensitive = true
#   value = acme_certificate.certificate.private_key_pem
# }
# output "ssl_cert" {
#   sensitive = true
#   value = acme_certificate.certificate.certificate_pem
# }

# output "ssl_key2" {
#   sensitive = true
#   value = acme_certificate.certificate2.private_key_pem
# }
# output "ssl_cert2" {
#   sensitive = true
#   value = acme_certificate.certificate2.certificate_pem
# }

# output "groupshot_ssl_key" {
#   sensitive = true
#   value = acme_certificate.groupshot_certificate.private_key_pem
# }
# output "groupshot_ssl_cert" {
#   sensitive = true
#   value = acme_certificate.groupshot_certificate.certificate_pem
# }
