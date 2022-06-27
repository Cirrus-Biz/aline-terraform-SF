output "log_groups" {
  value = module.cloudwatch.log_groups
}

# returns map of streams and their log group
output "log_streams" {
  value = module.cloudwatch.log_streams
}
