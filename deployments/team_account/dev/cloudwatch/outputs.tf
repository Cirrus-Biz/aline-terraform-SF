output "log_groups" {
  value = module.cloudwatch.log_groups
}

# returns map of streams and their log group
output "log_streams" {
  value = module.cloudwatch.log_streams
}

# output "create_metric_filter" {
#   value = module.cloudwatch.create_metric_filter
# }

output "sns_topics" {
  value = module.cloudwatch.sns_topics
}
