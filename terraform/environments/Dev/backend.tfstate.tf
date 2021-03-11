terraform {
  backend "s3" {
    bucket = "infra-tf-backend"
    key    = "sss/dev/terraform/terraform.tfstate"
    region = "us-east-1"
  }
}
