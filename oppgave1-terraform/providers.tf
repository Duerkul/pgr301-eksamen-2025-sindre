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

  # In CI, avoid STS/account/IMDS calls by toggling these flags
  skip_credentials_validation = var.ci_mode
  skip_requesting_account_id  = var.ci_mode
  skip_metadata_api_check     = var.ci_mode

  # S3 path-style to minimize provider lookups in CI
  s3_use_path_style = var.ci_mode
}
