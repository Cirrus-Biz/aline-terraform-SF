output "aws_instances" {
  value = {
    for k,v in aws_instance.jenkins_workers:
        k => v
  }
}
