variable "ec2_vars" {
  type = map(object({
    instance_type = string
    tag_name = string
    tag_ansible = string
    subnet_id =  string
    vpc_security_group_ids = list(string)
    key_name = string
  }))
  description = "ec2_variables"
}
