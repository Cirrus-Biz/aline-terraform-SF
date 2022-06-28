# project variables
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "infra_region" {
    type = string
    description = "region for this infrastructure | helps with tagging"
}


variable "infra_env" {
  type        = string
  description = "infrastructure environment (dev|prod|etc) | helps with tagging"
  default = "dev"
}


variable "project_name" {
  type        = string
  description = "name of project | helps with tagging"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "log_groups" {
  type = list(string)
  description = "list of log group names"
}

variable "log_streams" {
  type = map(string)
  description = "log stream name for key | log stream group for value"
  # example
  # log_streams = {
  #   "log_stream_name" = "log_stream_group"
  # }
}

variable "create_metric_filters" {
    type = map(object({
        name = string
        pattern = string
        log_group_name = string
        metric_name = string
        metric_value = string
        metric_unit = string
    }))
    description = "list of maps creating metric filters"
}

variable "create_metric_alarms" {
    type = map(object({
      namespace                 = string
      alarm_name                = string
      metric_name               = string
      statistic                 = string
      period                    = string
      comparison_operator       = string
      evaluation_periods        = string
      threshold                 = string
      alarm_description         = string
    }))
    description = "map of objects creating metric alarms"
}

variable "create_sns_topics" {
  type = list(string)
  description = "list of created sns topics"
}

variable "create_topic_subscriptions" {
    type = map(object({
      topic_arn = string
      endpoint  = string
    }))
    description = "map of objects creating topic subscriptions"
}
