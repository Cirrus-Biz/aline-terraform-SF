output "vpc_id" {
  value = module.vpc.vpc_id
}
 
output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}
 
output "vpc_public_subnets" {
  # returns map of public subnet id to cidr block
  value = module.vpc.vpc_public_subnets
}
 
output "vpc_private_subnets" {
  # returns map of private subnets id to cidr block
  value = module.vpc.vpc_private_subnets
}

output "nat_eip" {
    value = module.vpc.nat_eip
}

output "aws_route_table_public" {
    value = module.vpc.aws_route_table_public
}

output "aws_route_table_private" {
    value = module.vpc.aws_route_table_private
}

output "aws_network_acl_public" {
    value = module.vpc.aws_network_acl_public
}

output "aws_network_acl_private" {
    value = module.vpc.aws_network_acl_private
}
