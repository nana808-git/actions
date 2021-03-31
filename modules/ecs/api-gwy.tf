resource "aws_api_gateway_vpc_link" "main" {
  name        = "${var.cluster_name}-${var.environment}-vpc-link"
  description = "allows public API Gateway to talk to private NLB"
  target_arns = [aws_lb.app_nlb.arn]
}

resource "aws_api_gateway_rest_api" "main" {
  name = "${var.cluster_name}-${var.environment}-rest-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "main" {
  rest_api_id      = aws_api_gateway_rest_api.main.id
  resource_id      = aws_api_gateway_resource.main.id
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = false
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.main.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.app_nlb.dns_name}/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.main.id
  timeout_milliseconds    = 29000 # 50-29000

  cache_key_parameters = ["method.request.path.proxy"]
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_method_response" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.main.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.main.http_method
  status_code = aws_api_gateway_method_response.main.status_code

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_deployment" "main" {
  depends_on  = ["aws_api_gateway_integration.main"]
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = "v1"
}


Error: Error creating API Gateway Integration: BadRequestException: Invalid integration URI specified

  on ../../../modules/ecs/api-gwy.tf line 32, in resource "aws_api_gateway_integration" "main":
  32: resource "aws_api_gateway_integration" "main" {


Error: Error creating API Gateway Integration Response: NotFoundException: Invalid Integration identifier specified

  on ../../../modules/ecs/api-gwy.tf line 57, in resource "aws_api_gateway_integration_response" "main":
  57: resource "aws_api_gateway_integration_response" "main" {