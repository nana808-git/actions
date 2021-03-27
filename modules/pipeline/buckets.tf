resource "aws_s3_bucket" "source" {
  bucket        = "${var.cluster_name}-${var.environment}-codepipeline-build-job"
  acl           = "private"
  force_destroy = true
}

