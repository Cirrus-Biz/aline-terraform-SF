module "jenkins_worker_ec2" {
    source = "../../../../modules/jenkins_worker_ec2"
    ec2_vars = var.ec2_vars
    instance_type_test = var.instance_type_test 
}
