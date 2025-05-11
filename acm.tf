#------------------------------------
# Certificate
# 東京リージョンで指定されたドメインに対するSSL/TLS証明書を作成し、
# その証明書のライフサイクルを管理する
#------------------------------------
# ALB用 ACM証明書 (東京リージョン)
resource "aws_acm_certificate" "tokyo_cert" {
  domain_name = var.domain
  # サブドメインの指定
  subject_alternative_names = ["*.${var.domain}"]
  validation_method         = "DNS"

  tags = {
    Name    = "${var.domain}-acm"
    Project = var.domain
  }

  # 証明書のライフサイクル管理 -> 新しい証明書を作成してから古い証明書を削除
  lifecycle {
    create_before_destroy = true
  }
  # この証明書の作成が依存するリソース -> route53
  depends_on = [
    aws_route53_zone.route53_zone
  ]
}

# route53のacm.tfに関連するリソースが消える記述とする
resource "aws_route53_record" "route53_acm_resolve" {
  for_each = {
    for dvo in aws_acm_certificate.tokyo_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  zone_id         = aws_route53_zone.route53_zone.id
  name            = each.value.name
  type            = each.value.type
  ttl             = 600
  records         = [each.value.record]
}

resource "aws_acm_certificate_validation" "cert_valid" {
  certificate_arn         = aws_acm_certificate.tokyo_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_acm_resolve : record.fqdn]
}


# CloudFront用 ACM証明書 (バージニアリージョン)
resource "aws_acm_certificate" "virginia_cert" {
  provider = aws.virginia

  domain_name = var.domain
  # サブドメインの指定
  subject_alternative_names = ["*.${var.domain}"]
  validation_method         = "DNS"

  tags = {
    Name    = "${var.domain}-acm"
    Project = var.domain
  }

  # 証明書のライフサイクル管理 -> 新しい証明書を作成してから古い証明書を削除
  lifecycle {
    create_before_destroy = true
  }
  # この証明書の作成が依存するリソース -> route53
  depends_on = [
    aws_route53_zone.route53_zone
  ]
}


