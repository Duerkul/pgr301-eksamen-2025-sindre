terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # In CI, avoid STS/account validation calls by toggling these flags
  skip_credentials_validation = var.ci_mode
  skip_requesting_account_id  = var.ci_mode
}
