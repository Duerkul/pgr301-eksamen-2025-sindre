resource "aws_s3_bucket" "app_bucket" {
  bucket = var.bucket_name
  force_destroy = false

  tags = {
    Project = var.project_name
    ManagedBy = "Terraform"
    Environment = "demo"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.app_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.app_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.app_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
