Observability setup

1) Structured logging in Lambda
- JSON logs with fields: event, ts, result, error. Already configured in oppgave2-sam/src/app.py
- Use CloudWatch Logs Insights example query:

  fields @timestamp, @message
  | filter event = 'analysis_complete'
  | parse @message /\"result\":\{\"score\":(?<score>[^,]+),\"label\":\"(?<label>[^\"]+)\"\}/
  | sort @timestamp desc

2) Custom Metrics
- Lambda emits PutMetricData for Requests, Errors, SentimentScore under namespace AiAlpha.
- CloudWatch dashboard (dashboard.json) visualizes these metrics.

3) Alarms
- cloudwatch-alarms.tf contains sample alarms for Lambda errors and API 5xx.
- Adjust function and API names to match your deployment.

4) Retention and cost
- Consider adding log retention via Terraform or SAM (LogGroup with retentionInDays) to manage costs.
