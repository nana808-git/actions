terraform {
  backend "s3" {
    bucket = "dt-infra"
    key    = "ss/dev/terraform/terraform.tfstate"
    region = "us-east-2"
  }
}
