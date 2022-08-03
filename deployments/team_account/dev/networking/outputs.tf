output "secret_create" {
  value = module.vpc.secret_create
  description = "name of secret directory"
}

output "vpc_id" {
  value = module.vpc.vpc_id
  description = "vpc id"
}
 
output "vpc_cidr" {
  value = module.vpc.vpc_cidr
  description = "vpc cidr"
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
  description = "vpc internet gateway id"
}
 
output "vpc_public_subnets" {
  value = module.vpc.vpc_public_subnets
  description = "returns map of public subnet id to cidr block"
}
 
output "vpc_private_subnets" {
  value = module.vpc.vpc_private_subnets
  description = "returns map of private subnets id to cidr block"
}

output "nat_eip" {
  value = module.vpc.nat_eip
  description = "EIP id for nat gateway"
}

output "aws_route_table_public" {
  value = module.vpc.aws_route_table_public
  description = "public route table id"
}

output "aws_route_table_private" {
  value = module.vpc.aws_route_table_private
  description = "private route table id"
}

output "aws_network_acl_public" {
  value = module.vpc.aws_network_acl_public
  description = "public network access control list"
}

output "aws_network_acl_private" {
  value = module.vpc.aws_network_acl_private
  description = "private network access control list"
}
