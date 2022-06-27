# project variables
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "infra_region" {
    type = string
    description = "region for this infrastructure | helps with tagging"
}


variable "infra_env" {
  type        = string
  description = "infrastructure environment (dev|prod|etc) | helps with tagging"
  default = "dev"
}


variable "project_name" {
  type        = string
  description = "name of project | helps with tagging"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "log_groups" {
  type = list(string)
  description = "list of log group names"
}

variable "log_streams" {
  type = map(string)
  description = "log stream name for key | log stream group for value"
  # example
  # log_streams = {
  #   "log_stream_name" = "log_stream_group"
  # }
}
