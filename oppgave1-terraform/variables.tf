variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "aialpha"
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create (must be globally unique)"
  type        = string
  default     = "aialpha-tf-duerkul-20251119"
}

variable "ci_mode" {
  description = "If true, configure provider to skip credential/account validation during CI plan"
  type        = bool
  default     = false
}
