resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = "${aws_s3_bucket.bucket.bucket_regional_domain_name}"
    origin_id   = "s3"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.OAI.cloudfront_access_identity_path}"
    }
  }

  origin {
    domain_name = "${var.alb_dns_name}"
  
    origin_id   = "ELB"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"]
    }
  }

  enabled             = true
  default_root_object = "index.html"

  aliases = ["${var.app}.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "s3"

    default_ttl = 0
    min_ttl     = 0
    max_ttl     = 0

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "ELB"
    cache_policy_id  = "${aws_cloudfront_cache_policy.main.id}"

    viewer_protocol_policy = "redirect-to-https"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    #cloudfront_default_certificate = true
    iam_certificate_id             = "${var.ssl_certificate_id}"
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2019"
  }

  custom_error_response {
    error_caching_min_ttl = 86400
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 86400
    error_code = 403
    response_code = 200
    response_page_path = "/api/*"
  }
}

resource "aws_cloudfront_cache_policy" "main" {
  name        = "${var.cluster_name}-${var.environment}-origin-cache-policy"
  comment     = "cache headers"
  default_ttl = 1
  max_ttl     = 2
  min_ttl     = 1

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "all"
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Authorization", "Host"]
      }
    }
    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "OAI" {
}

## Route 53
data "aws_route53_zone" "main" {
  name         = "${var.domain_name}."
  private_zone = false
}

# Creates the DNS record to point on the CloudFront distribution ID that handles the redirection website
resource "aws_route53_record" "website_cdn_redirect_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.app}.${var.domain_name}."
  type    = "CNAME"
  ttl     = "60"

  records = ["${aws_cloudfront_distribution.distribution.domain_name}"]
}