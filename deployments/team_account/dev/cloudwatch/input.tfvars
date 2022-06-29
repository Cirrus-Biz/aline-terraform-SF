# project variables
infra_region = "us-east-1"
infra_env = "dev"
project_name = "aline-sf"

# create log group | retention in days 
log_groups = {
    "SF_Test_Log_Group" = 180
}

# create log stream | log group name 
log_streams = {
                "sf_test_log_stream" = "SF_Test_Log_Group"
               }

# create metric filter | assign to log group | create metrics
create_metric_filters = {
    metric_filter_1 = {
        name = "SF-Jenkins-Pipeline-ERROR"
        pattern = "ERROR"
        log_group_name = "SF-Jenkins-Pipeline"

        metric_name = "SF-Jenkins-Pipeline-ERROR"
        metric_namespace = "AWS/Logs"
        metric_value = "1.0"
        metric_unit = "Count"
    }
}

# creates metric alarm with sns notifications | alarm actions based on arn
# use "aws sns list-topics" in cli to get sns topic arn 
create_metric_alarms = {
    metric_alarm_1 = {
      namespace                 = "AWS/Logs"
      alarm_name                = "SF-Jenkins-Pipeline-ERROR"
      metric_name               = "SF-Jenkins-Pipeline-ERROR"
      statistic                 = "Sum"
      period                    = "60"
      comparison_operator       = "GreaterThanOrEqualToThreshold"
      evaluation_periods        = "1"
      threshold                 = "1"
      alarm_description         = "Test description"
      actions_enabled           = "true"
      alarm_actions   = ["arn:aws:sns:us-east-1:744758641322:SF-Jenkins-Pipeline-Logs"]
    }
}

# create sns topic
create_sns_topics = ["SF-Jenkins-Pipeline-Logs-Test"]

# create sns subscription by email using topic arn
# use "aws sns list-topics" in cli to get sns topic arn 
create_topic_subscriptions = {
    subscription_1 = {
      topic_arn = "arn:aws:sns:us-east-1:744758641322:SF-Jenkins-Pipeline-Logs"
      endpoint  = "stephen.freed@smoothstack.com"
    }
}
