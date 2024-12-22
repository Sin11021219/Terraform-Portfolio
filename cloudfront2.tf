#=================================================================
#CloudFront
#==================================================================
resource "aws_cloudfront_distribution" "cloudfront" {
    enabled         = true
    is_ipv6_enabled = true
    comment         = "cache distribution"
    price_class     = "PriceClass_All"

    origin {
        domain_name = aws_route53_record.route53_alb.fqdn
        origin_id   = aws_lb.alb.name

        custom_origin_config {
          origin_protocol_policy  = "match-viewer"
          origin_ssl_protocols    = ["TLSv1", "TLSv1.1", "TLSv1.2]
          http_port               = 80
          https_port              = 443
        }
    }

    default_cache_behaivar {
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]

        forwarded_values {
            query_string = true
            cookies {
                forward = "all"
            }
        }
        target_origin_id       = aws_lb.alb.name
        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        default_ttl            = 0
        max_ttl                = 0

    }
    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }
    aliases = ["cf.${var.domain}"]
     
    viewer_certificate {
        acm_certificate_arn      = aws_acm_certificate.virginia_cert.arn
        minimum_protocol_version = "TLSv1.2_2021"
        ssl_support_method       = "sni-only"
    }
}





