ec2_vars  = {
  ec2_1 = {
    # instance_type = "t2.micro"
    instance_type = "T00.micro"
    tag_name = "Jenkins_Worker_10_SF-1"
    tag_ansible = "Jenkins-Worker-SF"
  }
  # ec2_2 = {
  #   instance_type = "t2.micro"
  #   tag_name = "Swift-Worker-SF"
  #   tag_ansible = "Swift-Worker-SF"
  # }
}

instance_type_test = "T33.micro"
