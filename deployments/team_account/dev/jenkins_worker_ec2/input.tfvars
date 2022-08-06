//test
ec2_vars  = {
  ec2_1 = {
    instance_type = "t2.micro"
    tag_name = "Jenkins-Worker-SF-Test1"
    tag_ansible = "Jenkins-Worker-SF"
    subnet_id = "subnet-09465c4cc7ae87791"
    vpc_security_group_ids = ["sg-0dfc4a6e9f9aea008"] 
    key_name = "TeamJenkins"
  },
  ec2_2 = {
    instance_type = "t2.micro"
    tag_name = "Jenkins-Worker-SF-Test2"
    tag_ansible = "Jenkins-Worker-SF"
    subnet_id = "subnet-09465c4cc7ae87791"
    vpc_security_group_ids = ["sg-0dfc4a6e9f9aea008"] 
    key_name = "TeamJenkins"
  }
}
