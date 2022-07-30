terraform {

  required_version = ">= 0.12.0"

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
  profile = "aline-sf"
  shared_config_files = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
}

