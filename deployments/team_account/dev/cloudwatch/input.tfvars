# project variables
infra_region = "us-east-1"
infra_env    = "dev"
project_name = "aline-sf"

# create log group | retention in days 
log_groups = {
  "SF_Terraform_Pipeline_Dev_Logs" = 180
}

# create log stream | log group name 
log_streams = {
  "SF_Terraform_Pipeline_ERROR"   = "SF_Terraform_Pipeline_Dev_Logs"
  "SF_Terraform_Pipeline_APPLIED" = "SF_Terraform_Pipeline_Dev_Logs"
}

# create metric filter | assign to log group | create metrics
create_metric_filters = {
  metric_filter_1 = {
    name           = "SF_Terraform_Pipeline_ERROR"
    pattern        = "ERROR"
    log_group_name = "SF_Terraform_Pipeline_Dev_Logs"

    metric_name      = "SF_Terraform_Pipeline_ERROR"
    metric_namespace = "SF_Terraform_Pipeline_Dev_Logs"
    metric_value     = "1.0"
    metric_unit      = "Count"
  }
}

# creates metric alarm with sns notifications | alarm actions based on arn
# use "aws sns list-topics" in cli to get sns topic arn 
create_metric_alarms = {
  metric_alarm_1 = {
    namespace           = "SF_Terraform_Pipeline_Dev_Logs"
    alarm_name          = "SF_Terraform_Pipeline_ERROR"
    metric_name         = "SF_Terraform_Pipeline_ERROR"
    statistic           = "Sum"
    period              = "60"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "1"
    threshold           = "1"
    alarm_description   = "Alerts Alarm On Any Log With ERROR And Sends To SNS Topic"
    actions_enabled     = "true"
    alarm_actions       = ["arn:aws:sns:us-east-1:744758641322:SF_Terraform_Pipeline_Dev_ERROR"]
  }
}

# create sns topic
create_sns_topics = ["SF_Terraform_Pipeline_Dev_ERROR"]

# create sns subscription by email using topic arn
# use "aws sns list-topics" in cli to get sns topic arn 
create_topic_subscriptions = {
  subscription_1 = {
    topic_arn = "arn:aws:sns:us-east-1:744758641322:SF_Terraform_Pipeline_Dev_ERROR"
    endpoint  = "stephen.freed@smoothstack.com"
  }
}
