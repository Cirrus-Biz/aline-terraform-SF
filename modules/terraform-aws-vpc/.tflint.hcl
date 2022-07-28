plugin "aws" {
    enabled = true
    version = "0.14.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

config {
    module = true
    force = false
    varfile = ["../../deployments/team_account/dev/networking/input.tfvars"]
}

