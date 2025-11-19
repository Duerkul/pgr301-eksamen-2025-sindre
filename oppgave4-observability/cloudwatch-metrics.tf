# Notes: Custom metrics are emitted by the Lambda via boto3 PutMetricData.
# This file demonstrates IAM policy example if provisioning via Terraform is desired.

# Example IAM policy document for allowing PutMetricData (attach to Lambda role if managing via TF)
# data "aws_iam_policy_document" "put_metric" {
#   statement {
#     actions   = ["cloudwatch:PutMetricData"]
#     resources = ["*"]
#     condition {
#       test     = "StringEquals"
#       variable = "cloudwatch:namespace"
#       values   = ["AiAlpha"]
#     }
#   }
# }
