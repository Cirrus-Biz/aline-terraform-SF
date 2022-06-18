# project variables
infra_region = "us-east-1"
infra_env = "dev"
project_name = "aline-sf"

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



# subnet splits from vpc with /16 would give /20 subnets
bits_for_subnet_cidr = "4"

# public nacl egress
nacl_public_egress = [
    {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 65535
    }
]

# public nacl ingress
nacl_public_ingress = [
    {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 65535
    }
]

# private nacl egress 
nacl_private_egress = [
    {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 65535
    }
]

# private nacl ingress 
nacl_private_ingress = [
    {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 65535
    }
]
