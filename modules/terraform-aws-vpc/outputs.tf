output "secret_create" {
  value = aws_secretsmanager_secret.secret_create.name
  description = "name of secret directory"
}

output "vpc_id" {
  value = aws_vpc.vpc.id
  description = "vpc id"
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
  description = "vpc cidr"
}

output "internet_gateway_id" {
  value = aws_internet_gateway.internet_gateway.id
  description = "vpc internet gateway id"
}

output "vpc_public_subnets" {
  value = {
    for subnet in aws_subnet.public :
    subnet.id => subnet.cidr_block
  }
  description = "returns map of public subnet id to cidr block"
}

output "vpc_private_subnets" {
  value = {
    for subnet in aws_subnet.private :
    subnet.id => subnet.cidr_block
  }
  description = "returns map of private subnets id to cidr block"
}

output "nat_eip" {
  value = aws_eip.nat_eip.id
  description = "EIP id for nat gateway"
}

output "aws_route_table_public" {
  value = aws_route_table.public.id
  description = "public route table id"
}

output "aws_route_table_private" {
  value = aws_route_table.private.id
  description = "private route table id"
}

output "aws_network_acl_public" {
  value = aws_network_acl.nacl_public.id
  description = "public network access control list"
}

output "aws_network_acl_private" {
  value = aws_network_acl.nacl_private.id
  description = "private network access control list"
}
