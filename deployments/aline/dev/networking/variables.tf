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


variable "vpc_cidr_block" {
    type = string
    description = "vpc cidr block | you should specify this"
    default = "10.0.0.0/16" 
}


variable "public_subnet_numbers" {
  type = map(number)
  description = "map of region AZ to number that should be used for public subnets"
  # example bellow
  # default = {
  #   "us-east-1a" = 1
  #   "us-east-1b" = 2
  #   "us-east-1c" = 3
  #   "us-east-1d" = 4
  #   "us-east-1e" = 5
  #   "us-east-1f" = 6
  # }
}
 

variable "private_subnet_numbers" {
  type = map(number)
  description = "map of region AZ to number that should be used for private subnets"
  # example bellow
  # default = {
  #   "us-east-1a" = 7
  #   "us-east-1b" = 8
  #   "us-east-1c" = 9
  #   "us-east-1d" = 10
  #   "us-east-1e" = 11
  #   "us-east-1f" = 12
  # }
}
 
 
