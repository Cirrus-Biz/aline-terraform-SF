
output "aws_instances_ids" {
    value = module.jenkins_worker_ec2.aws_instances_ids
    description = "map of ec2 ids | key is input map key from input.tfvars"
}
