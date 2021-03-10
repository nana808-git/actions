resource "aws_s3_bucket" "source" {
  bucket        = "${var.cluster_name}-${var.environment}-codepipeline-artifacts"
  acl           = "private"
  force_destroy = true
}

