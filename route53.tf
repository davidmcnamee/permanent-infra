
resource "aws_route53_zone" "main" {
  name = "vidmcnam.ee"
}

output "dns_nameservers" { value = aws_route53_zone.main.name_servers }

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

resource "aws_route53_record" "main_spf" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "vidmcnam.ee"
  type    = "TXT"
  ttl     = "300"
  records = [
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
    "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCIbzkxuegCDmFqEw2TzliL0cJsZvHBidAjEPYwECNKx12P5gnexDGf8mPdGDm0e/qzts\"\"dOm+12RZN6b4kAeln2+T4JfmjUfdagtsfk5KYNYlZXlkw0EpSLFkAjquyDQs6T3uMPG+PNqeAv5wya1IJA3yMmPPTDZnqQG+QA0R4ZNwIDAQAB"
  ]
}
