resource "aws_s3_bucket" "bucket" {
  bucket = "${var.cluster_name}-${var.environment}-react-app-bucket"
  acl    = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }  
}


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
