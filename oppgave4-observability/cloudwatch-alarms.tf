# Example CloudWatch Alarms for Lambda and API

variable "alarm_email" {
  description = "Email for SNS notifications (set up separately)"
  type        = string
  default     = ""
}

# Example: Alarm on Lambda Errors (requires function name)
variable "lambda_function_name" {
  description = "Lambda function name to monitor"
  type        = string
  default     = "aialpha-sam-ApiFunction-mGXbQbuOSrP0"
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.project_name}-lambda-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when Lambda has any errors"
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = var.lambda_function_name
  }
}

# Example: Alarm on API Gateway 5XXError
variable "rest_api_name" {
  description = "API Gateway REST API Name"
  type        = string
  default     = "aialpha-sam"
}

resource "aws_cloudwatch_metric_alarm" "apigw_5xx" {
  alarm_name          = "${var.project_name}-api-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when API Gateway returns server errors"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ApiName = var.rest_api_name
    Stage   = "Prod"
  }
}
