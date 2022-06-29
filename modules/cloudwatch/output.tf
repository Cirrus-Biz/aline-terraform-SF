output "log_groups" {
  value = aws_cloudwatch_log_group.create_log_group
}

output "log_streams" {
  value = aws_cloudwatch_log_stream.create_log_stream
}

output "sns_topics" {
  value = aws_sns_topic.create_sns_topic
}
