resource "aws_s3_bucket" "source" {
  bucket        = "${var.app["name"]}-${var.app["env"]}-codepipeline-output"
  acl           = "private"
  force_destroy = true
}

