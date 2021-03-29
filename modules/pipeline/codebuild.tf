locals {
  needsBuildArgs = length(var.build_args) > 0
  buildArgsCommandStr = "--build-arg ${join(
    " --build-arg ",
    formatlist("%s=%s", keys(var.build_args), values(var.build_args)),
  )}"
  build_options = format("%s %s", var.build_options, local.needsBuildArgs ? local.buildArgsCommandStr : "")
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "ss-dev-db-creds"
}

locals {
  ss-dev-db-creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

data "template_file" "buildspec" {
  template = file("${path.module}/templates/buildspec.yml")

  vars = {
    repository_url            = var.repository_url
    region                    = var.region
    environment               = var.environment
    cluster_name              = var.cluster_name
    container_name            = var.container_name
    security_group_ids        = join(",", var.subnet_ids)
    build_options             = local.build_options
    SQL_SERVER                = "${var.db_endpoint}"
    JUNGLESCOUT_USERNAME      = local.ss-dev-db-creds.JUNGLESCOUT_USERNAME
    JUNGLESCOUT_PASSWORD      = local.ss-dev-db-creds.JUNGLESCOUT_PASSWORD
    SQL_DB_USER               = local.ss-dev-db-creds.SQL_DB_USER 
    SQL_DB_PASSWORD           = local.ss-dev-db-creds.SQL_DB_PASSWORD
  }
}

resource "aws_codebuild_source_credential" "source-credentials" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = "{{resolve:secretsmanager:GITHUB_ACCESS:SecretString:GITHUB_ACCESS_TOKEN}}"
}


resource "aws_codebuild_project" "app_build" {
  name          = "${var.cluster_name}-${var.environment}-codebuild"
  build_timeout = "10"

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"

    // https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "JUNGLESCOUT_USERNAME"
      value = "${var.JUNGLESCOUT_USERNAME}"
    }
    environment_variable {
      name  = "JUNGLESCOUT_PASSWORD"
      value = "${var.JUNGLESCOUT_PASSWORD}"
    }
    environment_variable {
      name  = "SQL_DB_USER"
      value = "var.SQL_DB_USER"
    }
    environment_variable {
      name  = "SQL_SERVER"
      value = "${var.SQL_SERVER}"
    }
    environment_variable {
      name  = "SQL_DB_PASSWORD"
      value = "${var.SQL_DB_PASSWORD}"
    }
    environment_variable {
      name  = "SQL_DB_NAME"
      value = "sleestak"
    }
    environment_variable {
      name  = "SQL_PORT"
      value = "3306"
    }      
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec.rendered
  }
}

