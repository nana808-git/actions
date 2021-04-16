data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "aop-secret-credentials"
}

locals {
  aop-secret-credentials = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

data "template_file" "api_task" {
  template = file("${path.module}/task-definitions/api-task.json")

  vars = {
    image                     = "${var.repository_url}:latest"
    cluster_name              = var.cluster_name
    container_name            = "${var.cluster_name}-${var.environment}-node-api"
    environment               = var.environment
    region                    = var.region
    SQL_SERVER                = "${var.db_endpoint}"
    JUNGLESCOUT_USERNAME      = local.aop-secret-credentials.JUNGLESCOUT_USERNAME
    JUNGLESCOUT_PASSWORD      = local.aop-secret-credentials.JUNGLESCOUT_PASSWORD
    SQL_DB_USER               = local.aop-secret-credentials.SQL_DB_USER 
    SQL_DB_PASSWORD           = local.aop-secret-credentials.SQL_DB_PASSWORD
    WORDPRESS_SECRET_KEY      = local.aop-secret-credentials.WORDPRESS_SECRET_KEY
    container_port            = var.container_port
    log_group                 = aws_cloudwatch_log_group.web-app.name
    desired_task_cpu          = var.desired_task_cpu
    desired_task_memory       = var.desired_task_memory
    APP_WEB_URL               = "${var.ssl_web_prefix}${var.app}.${var.domain_name}"
    environment_variables_str = join(
      ",",
      formatlist(
        "{\"name\":%q,\"value\":%q}",
        keys(var.environment_variables),
        values(var.environment_variables),
      ),
    )
  }
}

resource "aws_ecs_task_definition" "web-api" {
  family                   = "${var.cluster_name}-${var.environment}-node-api"
  container_definitions    = data.template_file.api_task.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.desired_task_cpu
  memory                   = var.desired_task_memory

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_execution_role.arn
}
