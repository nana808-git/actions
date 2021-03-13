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
    action{
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "ECR"
      version = "1"
      output_artifacts = ["source"]
      configuration = {
        #RepositoryName = "${aws_ecr_repository.this.name}"
        RepositoryName = "${var.app_repository_name}"
        ImageTag       = "latest"
      }
    }

#  stage {
#    name = "Source"
#    action{
#      name = "Source"
#      category = "Source"
#      owner = "AWS"
#      provider = "CodeStarSourceConnection"
#      version = "1"
#      output_artifacts = ["source"]
#      configuration = {
#        FullRepositoryId = "${lookup(var.git_repository,"FullRepositoryId")}"
#        BranchName   = "${lookup(var.git_repository,"BranchName")}"
#        ConnectionArn = "${lookup(var.git_repository,"ConnectionArn")}"
#        OutputArtifactFormat = "CODE_ZIP"
#      }
#    }
#  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      #output_artifacts = ["BuildOutput"]
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
      name            = "Production"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["imagedefinitions"]
      version         = "1"

      configuration = {
        ClusterName = "${var.cluster_name}-${var.environment}-ecs-node"
        ServiceName = "${var.cluster_name}-${var.environment}-node-api"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}



