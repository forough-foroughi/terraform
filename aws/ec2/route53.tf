# Create a Route 53 hosted zone
resource "aws_route53_zone" "hosted-zone" {
  name = var.route53_zone_name

}

# Create a DNS record for direct IP 
resource "aws_route53_record" "dns-record" {
  zone_id = aws_route53_zone.hosted-zone.id
  name    = var.route53_zone_name
  type    = "A"
  records = [var.route53_IP_address]
  ttl     = 300

}

# Create a DNS record by ALB Scenario
resource "aws_route53_record" "dns-record-alb" {
  zone_id = aws_route53_zone.hosted-zone.id
  name    = var.route53_zone_name
  type    = "A"
  alias {
    name                   = aws_lb.ec2-app-lb.dns_name
    zone_id                = aws_lb.ec2-app-lb.zone_id
    evaluate_target_health = true
  }
}

# Weighted routing policy for DNS record
resource "aws_route53_record" "dns-record-weighted" {
  zone_id = aws_route53_zone.hosted-zone.id
  name    = var.route53_zone_name
  type    = "A"
  ttl     = 300

  for_each       = var.weighted_route53_records
  set_identifier = each.key
  records        = [each.value.ip_address]
  weighted_routing_policy {
    weight = each.value.weight
  }
}

