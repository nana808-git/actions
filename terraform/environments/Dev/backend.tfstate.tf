terraform {
  backend "s3" {
    bucket = "infra-tf-backend"
    key    = "ss/dev/terraform/terraform.tfstate"
    region = "us-east-1"
  }
}
