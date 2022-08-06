module "jenkins_worker_ec2" {
    source = "../../../../modules/terraform-aws-jenkins_worker"
    ec2_vars = var.ec2_vars
}
