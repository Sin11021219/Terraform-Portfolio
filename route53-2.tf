#============================================================================
# route53
#============================================================================
resource "aws_route53_zone" "route53_zone" {
    name          = var.domain
    force_destroy = false
    tags = {
        Name    = "${var.project}-domain"
        Project = var.project 
    }
}

#========================================================================
#Route53 record
#========================================================================

resource "aws_route53_record" "route53_alb" {
    zone_id = aws_route53_zone.route53_zone.id
    name    = "alb.${var.domain}"
    type    = "A"

    alias {
        name                   = aws_lb.alb.dns_name
        zone_id                = aws_lb.alb.zone_id
        evaluate_target_health = true
    }
}

#CloudFrontへ独自ドメインを紐づける
resource "aws_route53_record" "route53_cloudfront" {
    zone_id = aws_route53_zone.route53_zone.id
    name    = cf."${var.domain}"
    type    = "A"

    alias {
        name                   = aws_cloudfront_distribution.cloudfront.domian_name
        zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
        evaluate_target_health = true
    }

}
