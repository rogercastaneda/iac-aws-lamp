data "aws_route53_zone" "domain" {
  name = "${var.domain}."
}
data "aws_acm_certificate" "com" {
  domain      = "*.${var.domain}"
  statuses    = ["ISSUED"]
  most_recent = true
  types       = ["AMAZON_ISSUED"]
}

data "aws_ami" "base" {
  most_recent = true
  name_regex  = "^my_ami_name"
  owners      = ["self"]
}

resource "aws_route53_record" "com" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}
