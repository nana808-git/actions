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

data "template_file" "codepipeline_events" {
  template = file("${path.module}/templates/policies/codepipeline-source-event.json")
  vars = {
    codepipeline_names = jsonencode(aws_codepipeline.pipeline[*].name)
  }
}

data "template_file" "codepipeline_events_sns" {
  template = file("${path.module}/templates/policies/sns-cloudwatch-events-policy.json")
  vars = {
    sns_arn = aws_sns_topic.codepipeline_events.arn
  }
}

resource "aws_cloudwatch_event_rule" "codepipeline_events" {
  name        = "${var.app_repository_name}-${var.environment}-pipeline-events"
  description = "Amazon CloudWatch Events rule to automatically post SNS notifications when CodePipeline state changes."
  event_pattern = data.template_file.codepipeline_events.rendered
}

resource "aws_sns_topic" "codepipeline_events" {
  name         = "${var.app_repository_name}-${var.environment}-codepipeline-events"
  display_name = "${var.app_repository_name}-${var.environment}-codepipeline-events"
}

resource "aws_sns_topic_policy" "codepipeline_events" {
  arn = aws_sns_topic.codepipeline_events.arn
  policy = data.template_file.codepipeline_events_sns.rendered
}

resource "aws_cloudwatch_event_target" "codepipeline_events" {
  rule      = aws_cloudwatch_event_rule.codepipeline_events.name
  target_id = "${var.app_repository_name}-${var.environment}-codepipeline"
  arn       = aws_sns_topic.codepipeline_events.arn
}

resource "aws_iam_role" "events" {
  name = "${var.app_repository_name}-${var.environment}-iam-events-role"
  assume_role_policy = file("${path.module}/templates/policies/events_role.json")
}

data "template_file" "events" {
  template = file("${path.module}/templates/policies/events-role_policy.json")
  vars = {
    codepipeline_arn = aws_codepipeline.pipeline.arn
  }
}

resource "aws_iam_role_policy" "ecr-events" {
  name   = "${var.app_repository_name}-${var.environment}-events-role-policy"
  role   = aws_iam_role.events.id
  policy = data.template_file.events.rendered
}

data "template_file" "ecr_event" {
  template = file("${path.module}/templates/policies/ecr-source-event.json")
  vars = {
    repository_name = var.repository_name
  }
}

resource "aws_cloudwatch_event_rule" "events" {
  name        = "${var.cluster_name}-${var.environment}-ecr-event"
  description = "Amazon CloudWatch Events rule to automatically start your pipeline when a change occurs in the Amazon ECR image tag."
  event_pattern = data.template_file.ecr_event.rendered
  depends_on = [aws_codepipeline.pipeline]
}

resource "aws_cloudwatch_event_target" "events" {
  rule      = aws_cloudwatch_event_rule.events.name
  target_id = "${var.cluster_name}-${var.environment}-pipeline"
  arn       = aws_codepipeline.pipeline.arn
  role_arn  = aws_iam_role.events.arn
}







