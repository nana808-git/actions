output "domain" {
  value = "${aws_cloudfront_distribution.distribution.domain_name}"
}

output "cname" {
  value = "${aws_route53_record.website_cdn_redirect_record.name}"
}

output "s3-bucket" {
  value = "${aws_s3_bucket.bucket.bucket}"
}

output "cache_policy" {
  value = "${aws_cloudfront_cache_policy.main.id}"
}
