terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.17.1"
    }
  }

  backend "s3" {
  }

}

provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}
