module "vpc" {
    source = "../../../../modules/vpc"
    infra_region = var.infra_region
    infra_env = var.infra_env
    project_name = var.project_name
    vpc_cidr_block = var.vpc_cidr_block
    public_subnet_numbers = var.public_subnet_numbers
    private_subnet_numbers = var.private_subnet_numbers
    bits_for_subnet_cidr = var.bits_for_subnet_cidr
    nacl_public_egress = var.nacl_public_egress
    nacl_public_ingress = var.nacl_public_ingress    
    nacl_private_egress = var.nacl_private_egress
    nacl_private_ingress = var.nacl_private_ingress
}
