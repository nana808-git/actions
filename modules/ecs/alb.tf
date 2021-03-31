locals {
  can_ssl           = var.ssl_certificate_arn == "" ? false : true
  can_domain        = var.domain_name == "" ? false : true
  is_only_http      = local.can_ssl == false && local.can_domain == true
  is_redirect_https = local.can_ssl && local.can_domain ? true : false
}

resource "aws_lb" "app_nlb" {
  name                 = "${var.cluster_name}-${var.environment}-nlb-node"
  subnets              = var.availability_zones
  load_balancer_type   = "network"
  enable_cross_zone_load_balancing = "true"
  internal = false
  #security_groups      = [aws_security_group.alb_sg.id, aws_security_group.app_sg.id]

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-nlb-node"
    Environment = var.cluster_name
  }
}

resource "aws_lb_target_group" "api_target_group" {
  name        = "${var.cluster_name}-${var.environment}-tg-api"
  port        = var.container_port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  deregistration_delay = var.deregistration_delay

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    protocol            = "TCP"
    interval            = var.health_check_interval
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  #depends_on = [aws_lb.app_nlb]
}


resource "aws_lb_listener" "web_app" {
  #count             = local.can_ssl ? 0 : 1
  load_balancer_arn = aws_lb.app_nlb.id
  port              = var.alb_port
  protocol          = "TCP"
  #depends_on        = [aws_lb_target_group.api_target_group]

  default_action {
    target_group_arn = aws_lb_target_group.api_target_group.id
    type             = "forward"
  }
}
