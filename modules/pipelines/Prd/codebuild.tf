locals {
  needsBuildArgs = length(var.build_args) > 0
  buildArgsCommandStr = "--build-arg ${join(
    " --build-arg ",
    formatlist("%s=%s", keys(var.build_args), values(var.build_args)),
  )}"
  build_options = format("%s %s", var.build_options, local.needsBuildArgs ? local.buildArgsCommandStr : "")
}

data "template_file" "serverspec" {
  template = file("${path.module}/templates/serverspec.yml")

  vars = {
    repository_url            = var.repository_url
    repository_name           = var.repository_name
    region                    = var.region
    environment               = var.environment
    cluster_name              = var.cluster_name
    container_name            = var.container_name
    security_group_ids        = join(",", var.subnet_ids)
    build_options             = local.build_options
    SQL_SERVER                = "${var.db_endpoint}"
    JUNGLESCOUT_USERNAME      = var.JUNGLESCOUT_USERNAME
    WORDPRESS_SECRET_KEY      = var.WORDPRESS_SECRET_KEY
    JUNGLESCOUT_PASSWORD      = var.JUNGLESCOUT_PASSWORD
    SQL_DB_USER               = var.SQL_DB_USER
    SQL_DB_PASSWORD           = var.SQL_DB_PASSWORD
    APP_WEB_URL               = var.APP_WEB_URL
    ASANA_SECRET_KEY          = var.ASANA_SECRET_KEY
    STG_SQL_SERVER            = var.STG_SQL_SERVER
  }
}

resource "aws_codebuild_project" "server_build" {
  name          = "${var.cluster_name}-${var.environment}-server-build"
  build_timeout = "10"

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  vpc_config {
    vpc_id = var.vpc_id
    subnets = var.subnet_ids 
    security_group_ids = var.security_group
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
      name  = "WORDPRESS_SECRET_KEY"
      value = "${var.WORDPRESS_SECRET_KEY}"
    }
    environment_variable {
      name  = "SQL_DB_USER"
      value = "${var.SQL_DB_USER}"
    }
    environment_variable {
      name  = "SQL_SERVER"
      value = "${var.db_endpoint}"
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
      name  = "ASANA_SECRET_KEY"
      value = "${var.ASANA_SECRET_KEY}"
    }
    environment_variable {
      name  = "APP_WEB_URL"
      value = "${var.APP_WEB_URL}"
    }
    environment_variable {
      name  = "STG_SQL_SERVER"
      value = "${var.STG_SQL_SERVER}"
    }
    environment_variable {
      name  = "SQL_PORT"
      value = "3306"
    }      
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.serverspec.rendered
  }
}


data "template_file" "clientspec" {
  template = file("${path.module}/templates/clientspec.yml")

  vars = {
    repository_url            = var.repository_url
    repository_name           = var.repository_name
    region                    = var.region
    environment               = var.environment
    cluster_name              = var.cluster_name
    container_name            = var.container_name
    security_group_ids        = join(",", var.subnet_ids)
    build_options             = local.build_options
    SQL_SERVER                = "${var.db_endpoint}"
    JUNGLESCOUT_USERNAME      = var.JUNGLESCOUT_USERNAME
    WORDPRESS_SECRET_KEY      = var.WORDPRESS_SECRET_KEY
    JUNGLESCOUT_PASSWORD      = var.JUNGLESCOUT_PASSWORD
    SQL_DB_USER               = var.SQL_DB_USER
    SQL_DB_PASSWORD           = var.SQL_DB_PASSWORD
    APP_WEB_URL               = var.APP_WEB_URL
    ASANA_SECRET_KEY          = var.ASANA_SECRET_KEY
    STG_SQL_SERVER            = var.STG_SQL_SERVER
  }
}


resource "aws_codebuild_project" "client_build" {
  name          = "${var.cluster_name}-${var.environment}-client-build"
  build_timeout = "10"

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  vpc_config {
    vpc_id = var.vpc_id
    subnets = var.subnet_ids 
    security_group_ids = var.security_group
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
      name  = "WORDPRESS_SECRET_KEY"
      value = "${var.WORDPRESS_SECRET_KEY}"
    }
    environment_variable {
      name  = "SQL_DB_USER"
      value = "${var.SQL_DB_USER}"
    }
    environment_variable {
      name  = "SQL_SERVER"
      value = "${var.db_endpoint}"
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
      name  = "ASANA_SECRET_KEY"
      value = "${var.ASANA_SECRET_KEY}"
    }
    environment_variable {
      name  = "STG_SQL_SERVER"
      value = "${var.STG_SQL_SERVER}"
    }
    environment_variable {
      name  = "APP_WEB_URL"
      value = "${var.APP_WEB_URL}"
    }
    environment_variable {
      name  = "SQL_PORT"
      value = "3306"
    }      
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.clientspec.rendered
  }
}

data "template_file" "dbspec" {
  template = file("${path.module}/templates/dbspec.yml")

  vars = {
    repository_url            = var.repository_url
    repository_name           = var.repository_name
    region                    = var.region
    environment               = var.environment
    cluster_name              = var.cluster_name
    container_name            = var.container_name
    security_group_ids        = join(",", var.subnet_ids)
    build_options             = local.build_options
    SQL_SERVER                = "${var.db_endpoint}"
    file                      = "db-backup-$CODEBUILD_RESOLVED_SOURCE_VERSION.sql"
    JUNGLESCOUT_USERNAME      = var.JUNGLESCOUT_USERNAME
    WORDPRESS_SECRET_KEY      = var.WORDPRESS_SECRET_KEY
    JUNGLESCOUT_PASSWORD      = var.JUNGLESCOUT_PASSWORD
    SQL_DB_USER               = var.SQL_DB_USER
    SQL_DB_PASSWORD           = var.SQL_DB_PASSWORD
    APP_WEB_URL               = var.APP_WEB_URL
    ASANA_SECRET_KEY          = var.ASANA_SECRET_KEY
    STG_SQL_SERVER            = var.STG_SQL_SERVER
  }
}

resource "aws_codebuild_project" "db_build" {
  name          = "${var.cluster_name}-${var.environment}-db-migration"
  build_timeout = "10"

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  vpc_config {
    vpc_id = var.vpc_id
    subnets = var.subnet_ids 
    security_group_ids = var.security_group
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
      name  = "WORDPRESS_SECRET_KEY"
      value = "${var.WORDPRESS_SECRET_KEY}"
    }
    environment_variable {
      name  = "SQL_DB_USER"
      value = "${var.SQL_DB_USER}"
    }
    environment_variable {
      name  = "SQL_SERVER"
      value = "${var.db_endpoint}"
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
      name  = "ASANA_SECRET_KEY"
      value = "${var.ASANA_SECRET_KEY}"
    }
    environment_variable {
      name  = "STG_SQL_SERVER"
      value = "${var.STG_SQL_SERVER}"
    }
    environment_variable {
      name  = "APP_WEB_URL"
      value = "${var.APP_WEB_URL}"
    }
    environment_variable {
      name  = "SQL_PORT"
      value = "3306"
    }      
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.dbspec.rendered
  }
}
