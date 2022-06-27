module "cloudwatch" {
    source = "../../../../modules/cloudwatch"
    infra_region = var.infra_region
    infra_env = var.infra_env
    project_name = var.project_name
    log_groups = var.log_groups
    log_streams = var.log_streams
}
