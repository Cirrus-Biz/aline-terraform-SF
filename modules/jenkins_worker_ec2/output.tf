output "aws_instances" {
  # value = aws_instance.jenkins_workers.id
  # value = aws_instance.jenkins_workers[each.key]
  value = {
    for k,v in aws_instance.jenkins_workers:
        k => v
  }
}
