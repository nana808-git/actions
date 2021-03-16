locals {
  can_ssl           = var.ssl_certificate_arn == "" ? false : true
  can_domain        = var.domain_name == "" ? false : true
  is_only_http      = local.can_ssl == false && local.can_domain == true
  is_redirect_https = local.can_ssl && local.can_domain ? true : false
}

resource "aws_alb" "app_alb" {
  name            = "${var.cluster_name}-${var.environment}-alb-node"
  subnets         = var.availability_zones
  security_groups = [aws_security_group.alb_sg.id, aws_security_group.app_sg.id]

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-alb-node"
    Environment = var.cluster_name
  }
}

resource "aws_alb_target_group" "api_target_group" {
  name        = "${var.cluster_name}-${var.environment}-tg-api"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path = var.helth_check_path
    port = var.container_port
  }

  depends_on = [aws_alb.app_alb]
}

resource "aws_alb_listener" "web_app" {
  count             = local.can_ssl ? 0 : 1
  load_balancer_arn = aws_alb.app_alb.arn
  port              = var.alb_port
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.api_target_group]

  lifecycle {
    create_before_destroy = true
  }

  default_action {
    target_group_arn = aws_alb_target_group.api_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "web_app_ssl" {
  count             = local.can_ssl ? 1 : 0
  load_balancer_arn = aws_alb.app_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"

  certificate_arn = var.ssl_certificate_arn

  lifecycle {
    create_before_destroy = true
  }

  default_action {
    target_group_arn = aws_alb_target_group.api_target_group.arn
    type             = "forward"
  }
}


#data "aws_route53_zone" "selected" {
#  count = local.can_domain ? 1 : 0

#  name = "${var.domain_name}."
#  #name = "isvc.tech."
#}

# 
#resource "aws_route53_record" "alb_alias" {
#  count = local.can_domain ? 1 : 0

#  name    = var.domain_name
#  zone_id = data.aws_route53_zone.selected[0].zone_id
#  type    = "A"

#  lifecycle {
#    create_before_destroy = true
#  }

#  alias {
#    name                   = aws_alb.app_alb.dns_name
#    zone_id                = aws_alb.app_alb.zone_id
#    evaluate_target_health = true
#  }
#}


resource "aws_alb_listener" "web_app_http" {
  count = local.is_only_http ? 1 : 0

  load_balancer_arn = aws_alb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.api_target_group]

  lifecycle {
    create_before_destroy = true
  }

  default_action {
    target_group_arn = aws_alb_target_group.api_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "http_redirect_https" {
  count = local.is_redirect_https ? 1 : 0

  load_balancer_arn = aws_alb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  lifecycle {
    create_before_destroy = true
  }

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

## Route 53
data "aws_route53_zone" "main" {
  name         = "${var.domain_name}."
  private_zone = false
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = "${aws_s3_bucket.bucket.bucket_regional_domain_name}"
    origin_id   = "s3"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.OAI.cloudfront_access_identity_path}"
    }
  }

  origin {
    domain_name = "module.ecs.alb_dns_name"
  
    origin_id   = "ELB"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"]
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    #viewer_protocol_policy = "redirect-to-https"
    viewer_protocol_policy = "allow-all"
  }

  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ELB"

    default_ttl = 0
    min_ttl     = 0
    max_ttl     = 0

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    #viewer_protocol_policy = "redirect-to-https"
    viewer_protocol_policy = "allow-all"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    #cloudfront_default_certificate = true
    #acm_certificate_arn            = "var.ssl_certificate_arn"
    acm_certificate_arn            = "arn:aws:acm:us-east-1:667736119737:certificate/8a4cdeec-e44c-42c0-b4ce-c1d2dc12f657"
    #iam_certificate_id             = "var.ssl_certificate_id"
    #cloudfront_default_certificate = var.ssl_certificate_arn == null && var.ssl_certificate_id == null ? true : false
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.1_2016"
  }
}

output "domain" {
  value = "${aws_cloudfront_distribution.distribution.domain_name}"
}

# Creates the DNS record to point on the CloudFront distribution ID that handles the redirection website
resource "aws_route53_record" "website_cdn_redirect_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.cluster_name}-${var.environment}.${var.domain_name}."
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# -------------- Origin resources --------------

# s3 origin
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.cluster_name}-${var.environment}-react-bucket"
  acl    = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }  
}

#resource "aws_s3_bucket_object" "object" {
#  bucket = "${aws_s3_bucket.bucket.bucket}"
#  key    = "index.html"

#  content      = <<EOF
#<script>
#const call = (path) => async () => {
#	[...document.querySelectorAll("button")].forEach((b) => b.disabled = true);
#	const result = await (await fetch(path)).text();
#	document.querySelector("#result").innerText = result;
#	[...document.querySelectorAll("button")].forEach((b) => b.disabled = false);
#}
#const call_api = call("/api/");
#const call_api_path = call("/api/path");
#</script>
#<button onclick="call_api()">call /api/</button>
#<button onclick="call_api_path()">call /api/path</button>
#<p id="result"></p>
#EOF
#  content_type = "text/html"
#}

resource "aws_s3_bucket_policy" "OAI_policy" {
  bucket = "${aws_s3_bucket.bucket.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.OAI.iam_arn}"]
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "OAI" {
}

