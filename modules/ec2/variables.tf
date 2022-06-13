 
variable "infra_region" {
    type = string
    description = "region for this infrastructure | helps with tagging"
}


variable "infra_env" {
  type        = string
  description = "infrastructure environment (dev|prod|etc) | helps with tagging"
  default = "dev"
}


variable "project_name" {
  type        = string
  description = "name of project for tagging | helps with tagging"
}





 
variable infra_role {
  type = string
  description = "infrastructure purpose"
}
 
variable instance_size {
    type = string
    description = "ec2 type"
    default = "t2.micro"
}
 
variable instance_ami {
    type = string
    description = "Server image to use"
}
 
variable instance_root_device_size {
    type = number
    description = "Root bock device size in GB"
    default = 12
}
