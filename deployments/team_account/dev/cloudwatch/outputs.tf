output "log_groups" {
  value = module.terraform-aws-cloudwatch.log_groups
}

# returns map of streams and their log group
output "log_streams" {
  value = module.terraform-aws-cloudwatch.log_streams
}

# output "create_metric_filter" {
#   value = module.terraform-aws-cloudwatch.create_metric_filter
# }

output "sns_topics" {
  value = module.terraform-aws-cloudwatch.sns_topics
}
