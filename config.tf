terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.17.1"
    }
  }

  backend "s3" {
    bucket = "terraform-SF"
    key    = "aline/DISCRIPTION.tfstate"
    region = "us-east-1"
  }

}

provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

# tag = {
#     Name = "name of what this is"
#     Project = "track all things in project"
#     Environment = "environment in that project"
#     ManagedBy = "terraform"
# }

# associate to not loose eip

# dynamo db for locking state file

 # example for tags
 # variable "tags" {
 #   type = map(string)
 #   default = {}
 #   description = "tags for the ec2 instance"
 # }
 #
 #   tags = merge(
 #     {
 #       Name        = "cloudcasts-${var.infra_env}"
 #       Role        = var.infra_role
 #       Project     = "cloudcasts.io"
 #       Environment = var.infra_env
 #       ManagedBy   = "terraform"
 #     },
 #     var.tags
 #   )
# variable "vpc_tags" {
#     type = map(string)
#     description = "vpc tags"
#     default = {}
# }

