module "cloudwatch" {
    source = "../../../../modules/terraform-aws-cloudwatch"
    infra_region = var.infra_region
    infra_env = var.infra_env
    project_name = var.project_name
    log_groups = var.log_groups
    log_streams = var.log_streams
    create_metric_filters = var.create_metric_filters
    create_metric_alarms = var.create_metric_alarms
    create_sns_topics = var.create_sns_topics
    create_topic_subscriptions = var.create_topic_subscriptions
}
