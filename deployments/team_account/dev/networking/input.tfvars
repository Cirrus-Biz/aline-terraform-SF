infra_region = "us-east-1"
infra_env = "dev"
project_name = "aline-SF"

#vpc block
vpc_cidr_block = "10.0.0.0/17"

# specify AZ from region you would like to use
public_subnet_numbers = {
                        "us-east-1a" = 1
                        "us-east-1b" = 2
                        "us-east-1c" = 3
                        "us-east-1d" = 4
                        "us-east-1e" = 5
                        "us-east-1f" = 6
                        }

private_subnet_numbers = {
                        "us-east-1a" = 7
                        "us-east-1b" = 8
                        "us-east-1c" = 9
                        "us-east-1d" = 10
                        "us-east-1e" = 11
                        "us-east-1f" = 12
                        }
subnet_bits_for_split_public = "4"
subnet_bits_for_split_private = "4"
