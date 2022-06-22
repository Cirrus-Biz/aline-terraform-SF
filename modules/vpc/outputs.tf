output "secret_create" {
  value = aws_secretsmanager_secret.secret_create.name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
 
output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "internet_gateway_id" {
  value = aws_internet_gateway.internet_gateway.id
}
 
output "vpc_public_subnets" {
  # returns map of public subnet id to cidr block
  value = {
    for subnet in aws_subnet.public :
    subnet.id => subnet.cidr_block
  }
}
 
output "vpc_private_subnets" {
  # returns map of private subnets id to cidr block
  value = {
    for subnet in aws_subnet.private :
    subnet.id => subnet.cidr_block
  }
}

output "nat_eip" {
    value = aws_eip.nat_eip.id
}

output "aws_route_table_public" {
    value = aws_route_table.public.id
}

output "aws_route_table_private" {
    value = aws_route_table.private.id
}

output "aws_network_acl_public" {
    value = aws_network_acl.nacl_public.id
}

output "aws_network_acl_private" {
    value = aws_network_acl.nacl_private.id
}
