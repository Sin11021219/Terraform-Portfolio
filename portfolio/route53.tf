#------------------------------------
# route53
# force_destroy -> 既存のホストゾーンが作成されている場合に強制削除するか
#------------------------------------
resource "aws_route53_zone" "route53_zone" {
  name          = var.domain
  force_destroy = false
  tags = {
    Name    = "${var.project}-domain"
    Project = var.project
  }
}

#------------------------------------
# route53 record
# aws_route53_zoneではホストゾーンに独自ドメインを設定し、
# その独自ドメインになんのAWSリソースのDNS名を紐づけるかをaws_route53_recordで設定する
# ALBに独自ドメインを紐づける
#------------------------------------
resource "aws_route53_record" "route53_alb" {
  zone_id = aws_route53_zone.route53_zone.id
  name    = "alb.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_lb.cloudtech_alb.dns_name
    zone_id                = aws_lb.cloudtech_alb.zone_id
    evaluate_target_health = true
  }
}

# CloudFrontへ独自ドメインを紐づける
resource "aws_route53_record" "route53_cloudfront" {
  zone_id = aws_route53_zone.route53_zone.id
  name    = "cf.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudtech_cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.cloudtech_cloudfront.hosted_zone_id
    evaluate_target_health = true
  }
}