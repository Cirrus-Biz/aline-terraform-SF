package test

import (
    "fmt"
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/gruntwork-io/terratest/modules/random"
    "github.com/gruntwork-io/terratest/modules/aws"
    "github.com/stretchr/testify/assert"
)

func TestVPCModule(t *testing.T) {

    // pick a random aws region to test in
	awsRegion := aws.GetRandomStableRegion(t, []string{"us-east-1"}, nil)

    // some regions are missing instance types, so pick an available type based on region
	instanceType := aws.GetRecommendedInstanceType(t, awsRegion, []string{"t2.micro", "t3.micro"})

    // instance names
    instance1 := fmt.Sprintf("sf-terratest-jenkins-worker-%s", random.UniqueId())
    instance2 := fmt.Sprintf("sf-terratest-jenkins-worker-%s", random.UniqueId())

    // project variables
    infra_region := fmt.Sprintf("sf-terratest-%s-%s", awsRegion, random.UniqueId())
    infra_env := fmt.Sprintf("sf-terratest-dev-%s", random.UniqueId())
    project_name := fmt.Sprintf("sf-terratest-aline-sf-%s", random.UniqueId())

    // secrets directory name
    secret_create := fmt.Sprintf("sf-terratest-aline-sf-%s", random.UniqueId())

    // vpc block
    vpc_cidr_block := "10.0.0.0/17"

    // specify AZ from region you would like to use
    // value number matters add/subtract from end
    public_subnet_numbers := map[string]interface{}{
        "us-east-1a": 1,
        "us-east-1b": 2,
        "us-east-1c": 3,
        // "us-east-1d": 4,
        // "us-east-1e": 5,
        // "us-east-1f": 6,
    }

    private_subnet_numbers := map[string]interface{}{
        "us-east-1a": 4,
        "us-east-1b": 5,
        "us-east-1c": 6,
        // "us-east-1d": 4,
        // "us-east-1e": 5,
        // "us-east-1f": 6,
    }

    // subnet splits from vpc with /16 would give /20 subnets
    bits_for_subnet_cidr := "4"


    // public nacl ingress
    nacl_public_ingress := []map[string]interface{}{
            {
                protocol: "tcp",
                rule_no: 100,
                action: "allow",
                cidr_block: "0.0.0.0/0",
                from_port: 0,
                to_port: 65535,
            },
        }

    // public nacl egress
    nacl_public_egress := []map[string]interface{}{
            {
                protocol: "tcp",
                rule_no: 100,
                action: "allow",
                cidr_block: "0.0.0.0/0",
                from_port: 0,
                to_port: 65535,
            },
        }

    // private nacl ingress
    nacl_private_ingress := []map[string]interface{}{
            {
                protocol: "tcp",
                rule_no: 100,
                action: "allow",
                cidr_block: "0.0.0.0/0",
                from_port: 0,
                to_port: 65535,
            },
        }

    // private nacl egress
    nacl_private_egress := []map[string]interface{}{
            {
                protocol: "tcp",
                rule_no: 100,
                action: "allow",
                cidr_block: "0.0.0.0/0",
                from_port: 0,
                to_port: 65535,
            },
        }


    // the values to pass into the terraform cli struct with default retryable errors
    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

        // the path to where the module code is located
        TerraformDir: "../modules/terraform-aws-vpc",

        Vars: map[string]interface{}{
            "ec2_vars": ec2_vars,
            infra_region: var.infra_region,
            infra_env: var.infra_env,
            project_name = var.project_name,
            secret_create = var.secret_create,
            vpc_cidr_block = var.vpc_cidr_block,
            public_subnet_numbers = var.public_subnet_numbers,
            private_subnet_numbers = var.private_subnet_numbers,
            bits_for_subnet_cidr = var.bits_for_subnet_cidr,
            nacl_public_egress = var.nacl_public_egress,
            nacl_public_ingress = var.nacl_public_ingress,    
            nacl_private_egress = var.nacl_private_egress,
            nacl_private_ingress = var.nacl_private_ingress,
        },

        // setting environment variables, specifically the aws account
        EnvVars: map[string]string{
            "AWS_PROFILE": "aline-sf",
            "AWS_REGION": awsRegion,
        },

    })

    // run terraform init and apply on terraformOptions(struct with information)
    terraform.InitAndApply(t, terraformOptions)
    // destroy resources created by terraform Options
    defer terraform.Destroy(t, terraformOptions)

    // gets map of aws instances ids
    instanceIds := terraform.OutputMapOfObjects(t, terraformOptions, "aws_instances_ids")

    // convert type interface to string
    instance1_id := instanceIds["instance1"].(string)
    instance2_id := instanceIds["instance2"].(string)

    // get map of instance tags
    tagMapForInstance1 := aws.GetTagsForEc2Instance(t, awsRegion, instance1_id)
    tagMapForInstance2 := aws.GetTagsForEc2Instance(t, awsRegion, instance2_id)

    // check instance name is same as aws instance
    assert.Equal(t, instance1, tagMapForInstance1["Name"])
    assert.Equal(t, instance2, tagMapForInstance2["Name"])

     
}
