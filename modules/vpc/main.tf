# create vpc in region
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block 
  instance_tenancy = "default"
  tags = {
    Name = "${var.project_name}_${var.infra_region}_${var.infra_env}_vpc"
    Project = var.project_name
    Environment = var.infra_env
    ManagedBy = "terraform"
  }
}


# create internet gateway for created vpc
resource "aws_internet_gateway" "internet_gateway" {
  depends_on = [aws_vpc.vpc]
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.project_name}_${var.infra_region}_${var.infra_env}_internet_gateway"
    Project     = var.project_name
    Environment = var.infra_env
    VPC         = aws_vpc.vpc.id
    ManagedBy   = "terraform"
  }
}


# create 1 public subnet for each AZ specified in input.tfvars
resource "aws_subnet" "public" {
  depends_on = [aws_vpc.vpc]
  vpc_id = aws_vpc.vpc.id
  for_each = var.public_subnet_numbers
  # adds specifiec number of bits to vpc cider | 4 bits on /16 would split subnets to /20 cidr
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, var.bits_for_subnet_cidr, each.value)  
  availability_zone = each.key
  tags = {
    Name        = "${var.project_name}_${each.key}_${var.infra_env}_public_subnet"
    Project     = var.project_name
    Role        = "public"
    Environment = var.infra_env
    ManagedBy   = "terraform"
    Subnet      = "${each.key}_${each.value}"
  }
}

# create 1 private subnet for each az specified in input.tfvars
resource "aws_subnet" "private" {
  depends_on = [aws_vpc.vpc]
  vpc_id = aws_vpc.vpc.id
  for_each = var.private_subnet_numbers
  # adds specifiec number of bits to vpc cider | 4 bits on /16 would split subnets to /20 cidr
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, var.bits_for_subnet_cidr, each.value)  # 4 would be 2,048 IP addresses each off /17
  availability_zone = each.key
  tags = {
    Name        = "${var.project_name}_${each.key}_${var.infra_env}_private_subnet"
    Project     = var.project_name
    Role        = "private"
    Environment = var.infra_env
    ManagedBy   = "terraform"
    Subnet      = "${each.key}-${each.value}"
  }
}


# nat gateway eip
resource "aws_eip" "nat_eip" {
  vpc = true
  lifecycle {
    # prevent_destroy = true
  }
  tags = {
    Name        = "${var.project_name}_${var.infra_region}_${var.infra_env}_nat_eip"
    Project     = var.project_name
    Role        = "public"
    Environment = var.infra_env
    VPC         = aws_vpc.vpc.id
    ManagedBy   = "terraform"
  }
}


# create nat gateway
resource "aws_nat_gateway" "nat_gateway" {
  depends_on = [aws_eip.nat_eip]
  allocation_id = aws_eip.nat_eip.id
  # finds first public subnet | ngw needs to be on a public subnet with an igw access
  subnet_id = aws_subnet.public[element(keys(aws_subnet.public), 0)].id  # gets first public subnet id
  tags = {
    Name        = "${var.project_name}_${var.infra_region}_${var.infra_env}_nat_gateway"
    Project     = var.project_name
    Role        = "public"
    VPC         = aws_vpc.vpc.id
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}
 
# public route table (subnets with internet gateway)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name        = "${var.project_name}_${var.infra_region}_${var.infra_env}_public_route_table"
    Environment = var.infra_env
    Project     = var.project_name
    Role        = "public"
    VPC         = aws_vpc.vpc.id
    ManagedBy   = "terraform"
  }
}

 
# private route table (subnets with nat gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.project_name}_${var.infra_region}_${var.infra_env}_private_route_table"
    Environment = var.infra_env
    Project     = var.project_name
    Role        = "private"
    VPC         = aws_vpc.vpc.id
    ManagedBy   = "terraform"
  }
}
 

# public subnets associated with public route table
resource "aws_route_table_association" "public" {
  depends_on = [aws_route_table.public]
  for_each  = aws_subnet.public
  subnet_id = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

 
# private subnets associated with private route table
resource "aws_route_table_association" "private" {
  depends_on = [aws_route_table.private]
  for_each  = aws_subnet.private
  subnet_id = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}

# create public subnet nacl
resource "aws_network_acl" "nacl_public" {
  vpc_id = aws_vpc.vpc.id
  dynamic "egress" {
    for_each = var.nacl_public_egress
    content{
        protocol = egress.value.protocol
        rule_no = egress.value.rule_no
        action = egress.value.action
        cidr_block = egress.value.cidr_block
        from_port = egress.value.from_port
        to_port = egress.value.to_port
    }
  }
  dynamic "ingress" {
    for_each = var.nacl_public_egress
    content{
        protocol = ingress.value.protocol
        rule_no = ingress.value.rule_no
        action = ingress.value.action
        cidr_block = ingress.value.cidr_block
        from_port = ingress.value.from_port
        to_port = ingress.value.to_port
    }
  }
  tags = {
    Name = "${var.project_name}_${var.infra_region}_${var.infra_env}_nacl_public"
    Project = var.project_name
    Role = "public"
    Environment = var.infra_env
    ManagedBy = "terraform"
  }
}

# associate public subnets to public nacl
resource "aws_network_acl_association" "public" {
  depends_on = [aws_network_acl.nacl_public]
  network_acl_id = aws_network_acl.nacl_public.id
  for_each  = aws_subnet.public
  subnet_id = aws_subnet.public[each.key].id
}


# create private subnet nacl
resource "aws_network_acl" "nacl_private" {
  vpc_id = aws_vpc.vpc.id
  dynamic "egress" {
    for_each = var.nacl_private_egress
    content{
        protocol = egress.value.protocol
        rule_no = egress.value.rule_no
        action = egress.value.action
        cidr_block = egress.value.cidr_block
        from_port = egress.value.from_port
        to_port = egress.value.to_port
    }
  }
  dynamic "ingress" {
    for_each = var.nacl_private_egress
    content{
        protocol = ingress.value.protocol
        rule_no = ingress.value.rule_no
        action = ingress.value.action
        cidr_block = ingress.value.cidr_block
        from_port = ingress.value.from_port
        to_port = ingress.value.to_port
    }
  }
  tags = {
    Name = "${var.project_name}_${var.infra_region}_${var.infra_env}_nacl_private"
    Project = var.project_name
    Role = "private"
    Environment = var.infra_env
    ManagedBy = "terraform"
  }
}

# associate private subnets to private nacl
resource "aws_network_acl_association" "private" {
  depends_on = [aws_network_acl.nacl_private]
  network_acl_id = aws_network_acl.nacl_private.id
  for_each  = aws_subnet.private
  subnet_id = aws_subnet.private[each.key].id
}
