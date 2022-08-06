package terraform_aws_jenkins_worker_test

import (
    "fmt"
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/gruntwork-io/terratest/modules/random"
    "github.com/gruntwork-io/terratest/modules/aws"
    "github.com/stretchr/testify/assert"
    test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)


func TestJenkinsWorkerModule(t *testing.T) {

    /* 
    #####################################
    #        Module Test Inputs         #
    #####################################
    */

    // AWS profile to use
    awsProfile := "aline-sf"

    // the directory we have our terraform module code
	workingDir := "../../modules/terraform-aws-jenkins_worker"

    // pick a random aws region to test in
    awsRegion := aws.GetRandomStableRegion(t, []string{"us-east-1"}, nil)

	// unique id to namespace resources | helps not clash with existing resources or tests
	uniqueID := random.UniqueId()

    // instances to run tests on
    testInstances := map[string]string{
        "instance1": fmt.Sprintf("sf-terratest-jenkins-worker1-%s", uniqueID),
        "instance2": fmt.Sprintf("sf-terratest-jenkins-worker2-%s", uniqueID),
    }


    /* 
    #####################################
    #       InitAndApply & Destroy      #
    #####################################
    */

    // at the end of all stages, terraform destroy
	defer test_structure.RunTestStage(t, "cleanup", func() {
		destroyTerraform(t, workingDir)
	})

	// stage to terraform init and apply
	test_structure.RunTestStage(t, "deploy", func() {
		deployUsingTerraform(t, workingDir, awsRegion, awsProfile, uniqueID, testInstances)
	})


    /* 
    #####################################
    #            Validations            #
    #####################################
    */

	// validate EC2 names
	test_structure.RunTestStage(t, "validate", func() {
		validateEC2Names(t, workingDir, awsRegion, testInstances)
	})
}


// terraform destroy
func destroyTerraform(t *testing.T, workingDir string) {
	// load the terraform options saved by the earlier deploy stage
	terraformOptions := test_structure.LoadTerraformOptions(t, "./")
	terraform.Destroy(t, terraformOptions)
}

func deployUsingTerraform(t *testing.T, workingDir string, awsRegion string, awsProfile string, uniqueID string, testInstances map[string]string) {

    // some regions are missing instance types, so pick an available type based on region
	instanceType := aws.GetRecommendedInstanceType(t, awsRegion, []string{"t2.micro", "t3.micro"})

    // input map of test ec2 jenkins worker nodes
    ec2_vars := map[string]map[string]interface{}{
                    "instance1": {
                        "instance_type": instanceType,
                        "tag_name": testInstances["instance1"],
                        "tag_ansible": "sf-terratest-jenkins-worker",
                        "subnet_id": "subnet-09465c4cc7ae87791",
                        "vpc_security_group_ids": []string{"sg-0dfc4a6e9f9aea008"},
                        "key_name": "TeamJenkins",
                    },

                    "instance2": {
                        "instance_type": instanceType,
                        "tag_name": testInstances["instance2"],
                        "tag_ansible": "sf-terratest-jenkins-worker",
                        "subnet_id": "subnet-09465c4cc7ae87791",
                        "vpc_security_group_ids": []string{"sg-0dfc4a6e9f9aea008"},
                        "key_name": "TeamJenkins",
                    },
                }

	// terraformOptions := &terraform.Options{
    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

        // the path to where the module code is located
        TerraformDir: workingDir,

        Vars: map[string]interface{}{
            "ec2_vars": ec2_vars,
        },

        // setting environment variables, specifically the aws account
        EnvVars: map[string]string{
            "AWS_PROFILE": awsProfile,
            "AWS_REGION": awsRegion,
        },

	})

    // serializes and saves terraformoptions into the given folder | this allows reuse of terraformoptions
	test_structure.SaveTerraformOptions(t, "./", terraformOptions)

	// this will run "terraform init" and "terraform apply" and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}

func validateEC2Names(t *testing.T, workingDir string, awsRegion string, testInstances map[string]string) {
	// load the terraform options saved by the earlier deploy_terraform stage
	terraformOptions := test_structure.LoadTerraformOptions(t, "./")

    // gets map of aws instances ids | return type interface
    instanceIds := terraform.OutputMapOfObjects(t, terraformOptions, "aws_instances_ids")

    // convert type interface to string
    instance1_id := instanceIds["instance1"].(string)
    instance2_id := instanceIds["instance2"].(string)

    // get map of instance tags
    tagMapForInstance1 := aws.GetTagsForEc2Instance(t, awsRegion, instance1_id)
    tagMapForInstance2 := aws.GetTagsForEc2Instance(t, awsRegion, instance2_id)

    // check instance name is same as aws instance 1
    t.Run("Testing EC2 1 Name", func(t *testing.T) {
        assert.Equal(t, testInstances["instance1"], tagMapForInstance1["Name"])
    })

    // check instance name is same as aws instance 2
    t.Run("Testing EC2 2 Name", func(t *testing.T) {
        assert.Equal(t, testInstances["instance2"], tagMapForInstance2["Name"])
    })
}
