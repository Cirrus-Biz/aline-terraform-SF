module "vpc" {
    source = "../../../../modules/vpc"
    infra_region = var.infra_region
    infra_env = var.infra_env
    project_name = var.project_name
    vpc_cidr_block = var.vpc_cidr_block
    public_subnet_numbers = var.public_subnet_numbers
    private_subnet_numbers = var.private_subnet_numbers
}
