# for pipeline artifacts
resource "aws_s3_bucket" "source" {
  bucket        = "${var.cluster_name}-${var.environment}-codepipeline-artifacts"
  acl           = "private"
  force_destroy = true
}

#for react build output sync
resource "aws_s3_bucket" "build-bucket" {
  bucket = "${var.cluster_name}-${var.environment}-react-build"
  acl    = "public-read"
  force_destroy = true 
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "s3-build_policy" {
  bucket = "${aws_s3_bucket.build-bucket.id}"
  policy = "${data.aws_iam_policy_document.s3-build_policy.json}"
}

data "aws_iam_policy_document" "s3-build_policy" {
  statement {
    actions   = ["*"]
    resources = ["${aws_s3_bucket.build-bucket.arn}/*"]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

#for react build output copy backup
resource "aws_s3_bucket" "backup-bucket" {
  bucket = "${var.cluster_name}-${var.environment}-react-backup"
  acl    = "public-read"
  force_destroy = true 
}

resource "aws_s3_bucket_policy" "s3-backup_policy" {
  bucket = "${aws_s3_bucket.backup-bucket.id}"
  policy = "${data.aws_iam_policy_document.s3-backup_policy.json}"
}

data "aws_iam_policy_document" "s3-backup_policy" {
  statement {
    actions   = ["*"]
    resources = ["${aws_s3_bucket.backup-bucket.arn}/*"]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}