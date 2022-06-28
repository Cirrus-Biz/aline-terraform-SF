
# creates cloudwatch log group
resource "aws_cloudwatch_log_group" "create_log_group" {

  for_each = toset(var.log_groups)
  name = each.key
  retention_in_days = 180

  tags = {
    Name = "${var.project_name}_${var.infra_region}_${var.infra_env}_${each.key}_log_group"
    Project = var.project_name
    Environment = var.infra_env
    ManagedBy = "terraform"
  }
}

# creates cloudwatch log stream and assign it to a group
resource "aws_cloudwatch_log_stream" "create_log_stream" {
  depends_on = [aws_cloudwatch_log_group.create_log_group]
  for_each = var.log_streams
  name = each.key
  log_group_name = each.value
}

resource "aws_cloudwatch_log_metric_filter" "create_metric_filter" {
  for_each = var.create_metric_filters
  name = each.value.name  # "SF-Jenkins-Pipeline-ERROR"
  pattern = each.value.pattern  # "ERROR"
  log_group_name = each.value.log_group_name  # "SF-Jenkins-Pipeline"

  metric_transformation {

    name      = each.value.metric_name  # "SF-Jenkins-Pipeline-ERROR"
    namespace = "AWS/Logs"
    value     = each.value.metric_value  # "1.0"
    unit = each.value.metric_unit  # "Count"
  }

}

resource "aws_cloudwatch_metric_alarm" "create_metric_alarm" {
  for_each = var.create_metric_alarms
  namespace                 = each.value.namespace
  alarm_name = each.value.alarm_name
  metric_name               = each.value.metric_name
  statistic                 = each.value.statistic
  period                    = each.value.period
  comparison_operator       = each.value.comparison_operator
  evaluation_periods        = each.value.evaluation_periods
  threshold                 = each.value.threshold
  alarm_description         = each.value.alarm_description

  actions_enabled     = "true"
  alarm_actions       = ["arn:aws:sns:us-east-1:744758641322:SF-Jenkins-Pipeline-Logs"]
}

resource "aws_sns_topic" "create_sns_topic" {
  for_each = toset(var.create_sns_topics)
  name = each.key
}

resource "aws_sns_topic_subscription" "create_topic_subscription" {
  for_each = var.create_topic_subscriptions
  topic_arn = each.value.topic_arn
  protocol  = "email"
  endpoint  = each.value.endpoint
}
