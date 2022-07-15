
# # ec2 variables
# variable "ec2_vars" {
#   type = map(string)
#   description = "ec2_variables"
# }

variable "ec2_vars" {
  type = map(object({
    instance_type = string
    tag_name = string
    tag_ansible = string
  }))
  description = "ec2_variables"
}

variable "instance_type_test" {
    type = string
    description = "test"
}

