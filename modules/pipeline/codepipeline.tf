resource "aws_codepipeline" "pipeline" {
  name     = "${var.cluster_name}-${var.environment}-pipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-pipeline"  
  }
  artifact_store {
    location = "${aws_s3_bucket.source.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"
#    action {
#      name = "Image"
#      category = "Source"
#      owner = "AWS"
#      provider = "ECR"
#      version = "1"
#      #run_order = "1"
#      output_artifacts = ["ECR-Image"]
#      configuration = {
#        RepositoryName = "${var.cluster_name}-${var.environment}-ecr-node"
#        ImageTag       = "latest"
#      }
#    }
#    action {
#      name = "React-App"
#      category = "Source"
#      owner = "AWS"
#      provider = "S3"
#      version = "1"
#      output_artifacts = ["React-App"]
#
#      configuration = {
#        S3Bucket = "${aws_s3_bucket.build-bucket.bucket}"
#        S3ObjectKey = "build-output.zip"
#        PollForSourceChanges = "false"
#      }
#    }
    action {
      name = "GitHub"
      category = "Source"
      owner = "AWS"
      provider = "CodeStarSourceConnection"
      version = "1"
      #run_order = "2"
      output_artifacts = ["Github-Source"]
      configuration = {
        FullRepositoryId = "${lookup(var.git_repository,"FullRepositoryId")}"
        BranchName   = "${lookup(var.git_repository,"BranchName")}"
        ConnectionArn = "${lookup(var.git_repository,"ConnectionArn")}"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "DB-Migration"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["Github-Source"]
      output_artifacts = ["imagedefinitions"]

      configuration = {
        ProjectName = "${var.cluster_name}-${var.environment}-codebuild"
      }
    }
  }

  stage {
    name = "Staging"
    action {
      name             = "Approval"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      version          = "1"

      configuration = {
        CustomData = "Approve or Reject this change after running tests "
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Backend-Production"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["imagedefinitions"]
      version         = "1"
      run_order       = "1"

      configuration = {
        ClusterName = "${var.cluster_name}-${var.environment}-ecs-node"
        ServiceName = "${var.cluster_name}-${var.environment}-node-api"
        FileName    = "imagedefinitions.json"
      }
    }
    action {
      name            = "Frontend-Production"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["imagedefinitions"]
      version         = "1"
      run_order       = "2"

      configuration = {
        BucketName = "${var.s3-bucket}"
        Extract = "true"
      }
    }
  }
}

locals {
  webhook_secret = "super-secret"
}

resource "aws_codepipeline_webhook" "pipeline" {
  name            = "test-webhook-github-pipeline"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.pipeline.name

  authentication_configuration {
    secret_token = local.webhook_secret
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}




