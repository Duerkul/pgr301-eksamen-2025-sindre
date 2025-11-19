# Optional: Use S3 backend for remote state. Uncomment and set values to enable.
# terraform {
#   backend "s3" {
#     bucket         = "<your-remote-state-bucket>"
#     key            = "aialpha/terraform.tfstate"
#     region         = "eu-north-1"
#     dynamodb_table = "<your-lock-table>"
#     encrypt        = true
#   }
# }
