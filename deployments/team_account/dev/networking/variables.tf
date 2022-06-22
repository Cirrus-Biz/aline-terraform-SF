# project variables
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
  description = "name of project | helps with tagging"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

# secrets directory name
variable "secret_create" {
    type = string
    description = "name of secrets directory to hold base infrastructure secrets"
}


# vpc cidr block
variable "vpc_cidr_block" {
    type = string
    description = "vpc cidr block | you should specify this in input.tfvars"
    default = "10.0.0.0/16" 
}


# list of AZ to split public subnets into
variable "public_subnet_numbers" {
  type = map(number)
  description = "map of region AZ to number that should be used for public subnets"
  # example
  # public_subnet_numbers = {
  #   "us-east-1a" = 1
  #   "us-east-1b" = 2
  #   "us-east-1c" = 3
  #   "us-east-1d" = 4
  #   "us-east-1e" = 5
  #   "us-east-1f" = 6
  # }
}
 

# list of AZ to split private subnets into | should start after public number
variable "private_subnet_numbers" {
  type = map(number)
  description = "map of region AZ to number that should be used for private subnets"
  # example
  # private_subnet_numbers = {
  #   "us-east-1a" = 7
  #   "us-east-1b" = 8
  #   "us-east-1c" = 9
  #   "us-east-1d" = 10
  #   "us-east-1e" = 11
  #   "us-east-1f" = 12
  # }
}


# variable to set subnet cidr block size
# if vpc cidr block is /16 then 4 makes subnets a /20 cidr
variable "bits_for_subnet_cidr" {
    type = string
    description = "number to add onto vpc cidr for subnet cidr size"
}
 

# nacle public egress dynamic block
variable "nacl_public_egress" {
    type = list(object({
        protocol = string
        rule_no = number
        action = string
        cidr_block = string
        from_port = number
        to_port = number
    }))
    description = "dynamic block of public nacl egress rules"
}


# nacle public ingress dynamic block
variable "nacl_public_ingress" {
    type = list(object({
        protocol = string
        rule_no = number
        action = string
        cidr_block = string
        from_port = number
        to_port = number
    }))
    description = "dynamic block of public nacl ingress rules"
}


# nacle private egress dynamic block
variable "nacl_private_egress" {
    type = list(object({
        protocol = string
        rule_no = number
        action = string
        cidr_block = string
        from_port = number
        to_port = number
    }))
    description = "dynamic block of private nacl egress rules"
}


# nacle private ingress dynamic block
variable "nacl_private_ingress" {
    type = list(object({
        protocol = string
        rule_no = number
        action = string
        cidr_block = string
        from_port = number
        to_port = number
    }))
    description = "dynamic block of private nacl ingress rules"
}
