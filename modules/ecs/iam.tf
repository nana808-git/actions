# Cluster Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.cluster_name}-${var.environment}-ecs_task_role"
  assume_role_policy = file("${path.module}/policies/ecs-task-execution-role.json")
}

# Cluster Execution Policy
resource "aws_iam_role_policy" "ecs_execution_role_policy" {
  name   = "${var.cluster_name}-${var.environment}-role_policy"
  policy = file("${path.module}/policies/ecs-execution-role-policy.json")
  role   = aws_iam_role.ecs_execution_role.id
}

resource "aws_iam_role" "ecs_role" {
  name               = "${var.cluster_name}-${var.environment}-ecs_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_role.json
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "${var.cluster_name}-${var.environment}-role_policy"
  policy = data.aws_iam_policy_document.ecs_service_policy.json
  role   = aws_iam_role.ecs_role.id
}

# ECS Service Policy
data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect    = "Allow"
    sid       = ""
    resources = ["*"]

    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress",
    ]
  } 
}

# ECS Service Policy
data "aws_iam_policy_document" "ecs_service_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

data "template_file" "metric_dashboard" {
  template = file("${path.module}/policies/basic-dashboard.json")
  vars = {
    region         = var.region != "" ? var.region : data.aws_region.current.name
    alb_arn_suffix = aws_lb.app_alb.arn_suffix
    cluster_name   = aws_ecs_cluster.web-app.name
    service_name   = aws_ecs_service.web-api.name
  }
}

resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "${var.cluster_name}-${var.environment}-metrics-dashboard"
  dashboard_body = data.template_file.metric_dashboard.rendered
}









