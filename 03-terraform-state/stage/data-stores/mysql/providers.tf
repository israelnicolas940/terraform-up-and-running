terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.31.0"
    }
  }
  # backend "s3" {
  #   bucket       = "tf-up-and-running-tf-state"
  #   key          = "stage/data-stores/mysql/terraform.tfstate"
  #   region       = "us-east-1"
  #   use_lockfile = true
  #   encrypt      = true
  # }
}
provider "aws" {
  region = "us-east-2"
}
