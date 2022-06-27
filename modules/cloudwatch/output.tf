output "log_groups" {
  value = aws_cloudwatch_log_group.create_log_groups
}

output "log_streams" {
  value = aws_cloudwatch_log_stream.create_log_stream
}
