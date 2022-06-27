
# creates cloudwatch log group
resource "aws_cloudwatch_log_group" "create_log_groups" {

  for_each = toset(var.log_groups)
  name = each.key
  retention_in_days = 180

  tags = {
    Name = "${var.project_name}_${var.infra_region}_${var.infra_env}_${each.key}_log_group"
    Project = var.project_name
    Environment = var.infra_env
    ManagedBy = "terraform"
  }
}

resource "aws_cloudwatch_log_stream" "create_log_stream" {
  depends_on = [aws_cloudwatch_log_group.create_log_groups]
  for_each = var.log_streams
  name = each.key
  log_group_name = each.value
}
