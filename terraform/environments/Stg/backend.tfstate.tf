terraform {
  backend "s3" {
    bucket = "dt-infra"
    key    = "ss/stg/terraform/terraform.tfstate"
    region = "us-east-2"
  }
}
