output "log_groups" {
  value = module.cloudwatch.log_groups
  description = "log groups output"
  
}

# returns map of streams and their log group
output "log_streams" {
  value = module.cloudwatch.log_streams
  description = "log streams output"
}

output "sns_topics" {
  value = module.cloudwatch.sns_topics
  description = "sns topics output"
}
