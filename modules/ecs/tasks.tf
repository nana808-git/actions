data "template_file" "api_task" {
  template = file("${path.module}/task-definitions/api-task.json")

  vars = {
    cluster_name              = var.cluster_name
    container_name            = "${var.cluster_name}-${var.environment}-node-api"
    environment               = var.environment
    image                     = "${var.repository_url}:${var.image_tag}"
    region                    = var.region
    SQL_SERVER                = var.db_endpoint
    JUNGLESCOUT_USERNAME      = var.JUNGLESCOUT_USERNAME
    JUNGLESCOUT_PASSWORD      = var.JUNGLESCOUT_PASSWORD
    SQL_DB_USER               = var.SQL_DB_USER 
    SQL_DB_PASSWORD           = var.SQL_DB_PASSWORD
    WORDPRESS_SECRET_KEY      = var.WORDPRESS_SECRET_KEY
    APP_WEB_URL               = var.APP_WEB_URL 
    ASANA_SECRET_KEY          = var.ASANA_SECRET_KEY              
    container_port            = var.container_port
    log_group                 = aws_cloudwatch_log_group.web-app.name
    desired_task_cpu          = var.desired_task_cpu
    desired_task_memory       = var.desired_task_memory
   
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
