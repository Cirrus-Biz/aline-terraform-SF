output "aws_instances_ids" {
  value = {
    for ec2 in keys(aws_instance.jenkins_workers):
       ec2 => aws_instance.jenkins_workers[ec2].id
  }
  description = "map of ec2 ids | key is input map key from input.tfvars"
}
