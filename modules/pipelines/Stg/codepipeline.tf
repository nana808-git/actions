resource "aws_codepipeline" "pipeline" {
  name     = "${var.cluster_name}-${var.environment}-pipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-pipeline"  
  }
  artifact_store {
    location = "${var.cluster_name}-${var.environment}-codepipeline-build"
    type     = "S3"
    region   = "${var.region}"
  }

  artifact_store {
    location = "${var.cluster_name}-${var.prd_env}-codepipeline-build"
    type     = "S3"
    region   = "${var.prd_region}"
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
    name = "Build-Staging"
    action {
      name             = "Server-Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["Github-Source"]
      output_artifacts = ["Backend-Output-Stg"]

      configuration = {
        ProjectName = "${var.cluster_name}-${var.environment}-server-build"
      }
    }
    action {
      name             = "Client-Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["Github-Source"]
      output_artifacts = ["Frontend-Output-Stg"]

      configuration = {
        ProjectName = "${var.cluster_name}-${var.environment}-client-build"
      }
    }
    action {
      name             = "DB-Migration"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["Github-Source"]
      output_artifacts = ["DB-Output-Stg"]

      configuration = {
        ProjectName = "${var.cluster_name}-${var.environment}-db-migration"
      }
    }
  }

  stage {
    name = "Staging-Approval"
    action {
      name             = "Approval"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      version          = "1"

      configuration = {
        CustomData = "Approve or Reject to Staging Env "
      }
    }
  }

  stage {
    name = "Deploy-Staging"
    action {
      name            = "Backend-Staging"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["Backend-Output-Stg"]
      version         = "1"
      run_order       = "2"

      configuration = {
        ClusterName = "${var.cluster_name}-${var.environment}-ecs-node"
        ServiceName = "${var.cluster_name}-${var.environment}-node-api"
        FileName    = "imagedefinitions.json"
      }
    }
    action {
      name            = "Frontend-Staging"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["Frontend-Output-Stg"]
      version         = "1"
      run_order       = "1"

      configuration = {
        BucketName = "${var.cluster_name}-${var.environment}-aop-bucket"
        Extract = "true"
      }
    }
  }

  stage {
    name = "Production-Approval"
    action {
      name             = "Approval"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      version          = "1"

      configuration = {
        CustomData = "Approve or Reject to Production Env "
      }
    }
  }

  stage {
    name = "Build-Production"
    action {
      name             = "Server-Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["Github-Source"]
      output_artifacts = ["Backend-Output-Prd"]

      configuration = {
        ProjectName = "${var.cluster_name}-${var.environment}-server-build"
      }
    }
    action {
      name             = "Client-Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["Github-Source"]
      output_artifacts = ["Frontend-Output-Prd"]

      configuration = {
        ProjectName = "${var.cluster_name}-${var.environment}-client-build"
      }
    }
    action {
      name             = "DB-Migration"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      #region           = "${var.prd_region}"
      input_artifacts  = ["Github-Source"]
      output_artifacts = ["DB-Output-Prd"]

      configuration = {
        ProjectName = "${var.cluster_name}-${var.prd_env}-db-migration"
      }
    }
  }

  stage {
    name = "Deploy-Production"
    action {
      name            = "Backend-Production"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      region           = "${var.prd_region}"
      input_artifacts = ["Backend-Output-Prd"]
      version         = "1"
      run_order       = "1"

      configuration = {
        ClusterName = "${var.cluster_name}-${var.prd_env}-ecs-node"
        ServiceName = "${var.cluster_name}-${var.prd_env}-node-api"
        FileName    = "imagedefinitions.json"
      }
    }
    action {
      name            = "Frontend-Production"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      region           = "${var.prd_region}"
      input_artifacts = ["Frontend-Output-Prd"]
      version         = "1"
      run_order       = "2"

      configuration = {
        BucketName = "${var.cluster_name}-${var.prd_env}-aop-bucket"
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