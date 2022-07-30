package test

import (
    "fmt"
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/gruntwork-io/terratest/modules/random"
    "github.com/gruntwork-io/terratest/modules/aws"
    "github.com/stretchr/testify/assert"
)

func TestJenkinsWorkerModule(t *testing.T) {

    // pick a random aws region to test in
	awsRegion := aws.GetRandomStableRegion(t, []string{"us-east-1"}, nil)

    // some regions are missing instance types, so pick an available type based on region
	instanceType := aws.GetRecommendedInstanceType(t, awsRegion, []string{"t2.micro", "t3.micro"})

    // instance names
    instance1 := fmt.Sprintf("sf-terratest-jenkins-worker-%s", random.UniqueId())
    instance2 := fmt.Sprintf("sf-terratest-jenkins-worker-%s", random.UniqueId())

    // input map of test ec2 jenkins worker nodes
    ec2_vars := map[string]map[string]interface{}{
                    "instance1": {
                        "instance_type": instanceType,
                        "tag_name": instance1,
                        "tag_ansible": "sf-terratest-jenkins-worker",
                        "subnet_id": "subnet-09465c4cc7ae87791",
                        "vpc_security_group_ids": []string{"sg-0dfc4a6e9f9aea008"},
                        "key_name": "TeamJenkins",
                    },

                    "instance2": {
                        "instance_type": instanceType,
                        "tag_name": instance2,
                        "tag_ansible": "sf-terratest-jenkins-worker",
                        "subnet_id": "subnet-09465c4cc7ae87791",
                        "vpc_security_group_ids": []string{"sg-0dfc4a6e9f9aea008"},
                        "key_name": "TeamJenkins",
                    },
                }


    // the values to pass into the terraform cli struct with default retryable errors
    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

        // the path to where the module code is located
        TerraformDir: "../jenkins_worker_ec2",

        Vars: map[string]interface{}{
            "ec2_vars": ec2_vars,
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


