package test

import (
    "fmt"
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/gruntwork-io/terratest/modules/aws"

    "github.com/stretchr/testify/assert"
)

func TestJenkinsWorkerModule(t *testing.T) {

    // the values to pass into the terraform cli struct with default retryable errors
    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

        // the path to where the module code is located
        terraformDir: "../terraform-aws-jenkins_worker",

        // create test var names
        expectedClusterName := fmt.Sprintf("terratest-aws-ecs-example-cluster-%s", random.UniqueId())
        

        // Pick a random AWS region to test in. This helps ensure your code works in all regions.
        awsRegion := aws.GetRandomStableRegion(t, []string{"us-east-1", "eu-west-1"}, nil)

        // variables to use by module using -var options
        vars: map[string]interface{}{
            "something": "something",
            instance_type = "t3.medium"
            tag_name = "Jenkins-Worker-SF"
            tag_ansible = "Jenkins-Worker-SF"
            subnet_id = "subnet-09465c4cc7ae87791"
            vpc_security_group_ids = ["sg-0dfc4a6e9f9aea008"] 
            key_name = "TeamJenkins"
        },

    })

    // run terraform init and apply on terraformOptions(struct with information)
    terraform.InitAndApply(t, terraformOptions)
    // destroy resources created by terraform Options
    defer terraform.Destroy(t, terraformOptions)




     
}
