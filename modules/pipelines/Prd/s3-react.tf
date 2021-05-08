# for pipeline artifacts
resource "aws_s3_bucket" "source" {
  bucket        = "${var.cluster_name}-${var.environment}-codepipeline-artifacts"
  acl           = "private"
  force_destroy = true
}


#for react build output
resource "aws_s3_bucket" "build-bucket" {
  bucket = "${var.cluster_name}-${var.environment}-react-build-backup"
  acl    = "private"
  force_destroy = true 
}

resource "aws_s3_bucket_policy" "s3-build_policy" {
  bucket = "${aws_s3_bucket.build-bucket.id}"
  policy = "${data.aws_iam_policy_document.s3-build-policy.json}"
}

data "aws_iam_policy_document" "s3-build-policy" {
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

#for DB exprt dumps
resource "aws_s3_bucket" "db-backup-bucket" {
  bucket = "${var.cluster_name}-${var.environment}-db-backup"
  acl    = "private"
  force_destroy = true 
}

resource "aws_s3_bucket_policy" "s3-db-backup_policy" {
  bucket = "${aws_s3_bucket.db-backup-bucket.id}"
  policy = "${data.aws_iam_policy_document.s3-db-backup-policy.json}"
}

data "aws_iam_policy_document" "s3-db-backup-policy" {
  statement {
    actions   = ["*"]
    resources = ["${aws_s3_bucket.db-backup-bucket.arn}/*"]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
