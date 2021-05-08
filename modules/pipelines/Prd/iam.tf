
resource "aws_iam_role" "codebuild_role" {
  name               = "${var.app_repository_name}-${var.environment}-codebuild-role"
  assume_role_policy = file("${path.module}/templates/policies/codebuild_role.json")
}

data "template_file" "codebuild_policy" {
  template = file("${path.module}/templates/policies/codebuild_policy.json")
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "codebuild-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = data.template_file.codebuild_policy.rendered
}