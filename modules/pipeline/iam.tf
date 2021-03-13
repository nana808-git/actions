resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.app_repository_name}-${var.environment}-codepipeline-role"
  assume_role_policy = file("${path.module}/templates/policies/codepipeline_role.json")
}

data "template_file" "codepipeline_policy" {
  template = file("${path.module}/templates/policies/codepipeline.json")

  vars = {
    aws_s3_bucket_arn = aws_s3_bucket.source.arn
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.template_file.codepipeline_policy.rendered
}

resource "aws_iam_role" "events_role" {
  name               = "${var.app_repository_name}-${var.environment}-events-role"
  assume_role_policy = file("${path.module}/templates/policies/events_role.json")
}

data "template_file" "events_policy" {
  template = file("${path.module}/templates/policies/events-role_policy.json")
  vars = {
    codepipeline_arn = aws_codepipeline.pipeline.arn
  }
}

resource "aws_iam_role_policy" "events" {
  name   = "${var.app_repository_name}-${var.environment}-events-role-policy"
  role   = aws_iam_role.events_role.id
  policy = data.template_file.events_policy.rendered
}

resource "aws_iam_role" "codebuild_role" {
  name               = "${var.app_repository_name}-${var.environment}-codebuild-role"
  assume_role_policy = file("${path.module}/templates/policies/codebuild_role.json")
}

data "template_file" "codebuild_policy" {
  template = file("${path.module}/templates/policies/codebuild_policy.json")

  vars = {
    aws_s3_bucket_arn = aws_s3_bucket.source.arn
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "codebuild-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = data.template_file.codebuild_policy.rendered
}
