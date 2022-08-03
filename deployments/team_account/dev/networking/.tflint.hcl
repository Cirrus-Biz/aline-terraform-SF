config {
    # also inspect module calls
    module = true
    # return non 0 exit status on fail
    force = false
    # set terraform variables from tfvars files
    varfile = ["./input.tfvars"]
}

plugin "aws" {
    enabled = true
    version = "0.14.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# disallow deprecated (0.11-style) interpolation
rule "terraform_deprecated_interpolation" {
    enabled = true
}
 
# disallow legacy dot index syntax
rule "terraform_deprecated_index" {
    enabled = true
}
 
# disallow variables, data sources, and locals that are declared but never used.
rule "terraform_unused_declarations" {
    enabled = true
}
 
# disallow output declarations without description.
rule "terraform_documented_outputs" {
    enabled = true
}
 
# disallow variable declarations without description.
rule "terraform_documented_variables" {
    enabled = true
}
 
# disallow variable declarations without type
rule "terraform_typed_variables" {
    enabled = true
}
 
# disallow specifying a git or other repository as a module source without pinning to a version
rule "terraform_module_pinned_source" {
    enabled = true
}
 
# enforces naming conventions
rule "terraform_naming_convention" {

    enabled = true
     
    # require specific naming structure
    module {
        format = "snake_case"
    }

    locals {
        format = "snake_case"
    }

    variable {
        format = "snake_case"
    }
     
    resource {
        format = "snake_case"
    }
     
    data {
        format = "snake_case"
    }

    output {
        format = "snake_case"
    }
}
 
# disallow terraform declarations without require_version
rule "terraform_required_version" {
    enabled = true
}
 
# require that all providers have version constraints through required_providers.
rule "terraform_required_providers" {
    enabled = true
}
 
# ensure that a module complies with the terraform standard module structure
rule "terraform_standard_module_structure" {
    enabled = true
}
 
# terraform.workspace should not be used with a "remote" backend with remote execution.
rule "terraform_workspace_remote" {
    enabled = true
}
