# creates cloudwatch log group
resource "aws_cloudwatch_log_group" "create_log_group" {
  for_each          = var.log_groups
  name              = each.key
  retention_in_days = each.value

  tags = {
    Name        = "${var.project_name}_${var.infra_region}_${var.infra_env}_${each.key}_log_group"
    Project     = var.project_name
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}

# creates cloudwatch log stream and assign it to a group
resource "aws_cloudwatch_log_stream" "create_log_stream" {
  depends_on     = [aws_cloudwatch_log_group.create_log_group]
  for_each       = var.log_streams
  name           = each.key
  log_group_name = each.value
}

# creates cloud watch metric filter and assigns to group
resource "aws_cloudwatch_log_metric_filter" "create_metric_filter" {
  depends_on     = [aws_cloudwatch_log_group.create_log_group]
  for_each       = var.create_metric_filters
  name           = each.value.name
  pattern        = each.value.pattern
  log_group_name = each.value.log_group_name

  metric_transformation {
    name      = each.value.metric_name
    namespace = each.value.metric_namespace
    value     = each.value.metric_value
    unit      = each.value.metric_unit
  }

}

# creates metric alarm with sns notifications
resource "aws_cloudwatch_metric_alarm" "create_metric_alarm" {
  depends_on     = [aws_cloudwatch_log_metric_filter.create_metric_filter, aws_sns_topic.create_sns_topic]
  for_each            = var.create_metric_alarms
  namespace           = each.value.namespace
  alarm_name          = each.value.alarm_name
  metric_name         = each.value.metric_name
  statistic           = each.value.statistic
  period              = each.value.period
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  threshold           = each.value.threshold
  alarm_description   = each.value.alarm_description
  actions_enabled = each.value.actions_enabled
  alarm_actions   = each.value.alarm_actions

  tags = {
    Name        = "${var.project_name}_${var.infra_region}_${var.infra_env}_${each.value.alarm_name}"
    Project     = var.project_name
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}

# create sns topic
resource "aws_sns_topic" "create_sns_topic" {
  for_each = toset(var.create_sns_topics)
  name     = each.key

  tags = {
    Name        = "${var.project_name}_${var.infra_region}_${var.infra_env}_${each.key}_sns_topic"
    Project     = var.project_name
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}

# create sns topic subscription by email
resource "aws_sns_topic_subscription" "create_topic_subscription" {
  for_each  = var.create_topic_subscriptions
  topic_arn = each.value.topic_arn
  protocol  = "email"
  endpoint  = each.value.endpoint
}
