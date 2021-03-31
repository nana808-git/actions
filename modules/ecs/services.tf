locals {
  security_group_ids = [
    aws_security_group.app_sg.id,
    aws_security_group.alb_sg.id,
    aws_security_group.ecs_sg.id,
  ]
}

resource "aws_ecs_service" "web-api" {
  name            = "${var.cluster_name}-${var.environment}-node-api"
  task_definition = aws_ecs_task_definition.web-api.arn
  cluster         = aws_ecs_cluster.cluster.id
  launch_type     = "FARGATE"
  desired_count   = var.desired_tasks
  health_check_grace_period_seconds = "10"

  //  deployment_controller {
  //    type = "CODE_DEPLOY"
  //  }

  network_configuration {
    #security_groups  = local.security_group_ids
    security_groups = [aws_security_group.nlb_sg.id]
    subnets          = var.availability_zones
    assign_public_ip = true // false
  }

  load_balancer {
    #target_group_arn = aws_alb_target_group.api_target_group.arn
    target_group_arn = aws_lb_target_group.api_target_group.id
    container_name   = "${var.cluster_name}-${var.environment}-node-api"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      #load_balancer,
    ]
  }

  #depends_on = [aws_iam_role_policy.ecs_service_role_policy, aws_alb_target_group.api_target_group]
  depends_on = [aws_lb_listener.web_app]
}



  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.replicas

  network_configuration {
    security_groups = [aws_security_group.nsg_task.id]
    subnets         = split(",", var.private_subnets)
  }





