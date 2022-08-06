package  terraform_aws_vpc_test

import (
    "fmt"
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/gruntwork-io/terratest/modules/random"
    "github.com/gruntwork-io/terratest/modules/aws"
    // "github.com/stretchr/testify/assert"
    test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)


func TestAWSVPCModule(t *testing.T) {

    /* 
    #####################################
    #        Module Test Inputs         #
    #####################################
    */

    // AWS profile to use
    awsProfile := "aline-sf"

    // the directory we have our terraform module code
	workingDir := "../../modules/terraform-aws-vpc"

    // pick a random aws region to test in
    awsRegion := aws.GetRandomStableRegion(t, []string{"us-east-1"}, nil)

	// unique id to namespace resources | helps not clash with existing resources or tests
	uniqueID := random.UniqueId()


    vpcInputs := map[string]interface{}{

     
    // project variables
    "infra_region": fmt.Sprintf("sf-terratest-%s-%s", awsRegion, uniqueID),
    "infra_env": fmt.Sprintf("sf-terratest-test-%s", uniqueID),
    "project_name": fmt.Sprintf("sf-terratest-module-test-%s", uniqueID),

    // secrets directory name
    "secret_create": fmt.Sprintf("sf-terratest-secret-%s", uniqueID),

    // vpc block
    "vpc_cidr_block": "10.0.0.0/17",

    // specify AZ from region you would like to use in key[string]/value[int] pairs
    // value number matters add/subtract from end for public and private
    "public_subnet_numbers": map[string]interface{}{
        "us-east-1a": 1,
        "us-east-1b": 2,
        "us-east-1c": 3,
        // "us-east-1d": 4,
        // "us-east-1e": 5,
        // "us-east-1f": 6,
    },

    "private_subnet_numbers": map[string]interface{}{
        "us-east-1a": 4,
        "us-east-1b": 5,
        "us-east-1c": 6,
        // "us-east-1d": 4,
        // "us-east-1e": 5,
        // "us-east-1f": 6,
    },

    // subnet splits from vpc with /16 would give /20 subnets
    "bits_for_subnet_cidr": "4",

    // public nacl ingress rules | add rules in map blocks
    "nacl_public_ingress": []map[string]interface{}{
            {
                "protocol": "tcp",
                "rule_no": 100,
                "action": "allow",
                "cidr_block": "0.0.0.0/0",
                "from_port": 0,
                "to_port": 65535,
            },
        },

    // public nacl egress rules | add rules in map blocks
    "nacl_public_egress": []map[string]interface{}{
            {
                "protocol": "tcp",
                "rule_no": 100,
                "action": "allow",
                "cidr_block": "0.0.0.0/0",
                "from_port": 0,
                "to_port": 65535,
            },
        },

    // private nacl ingress rules | add rules in map blocks
    "nacl_private_ingress": []map[string]interface{}{
            {
                "protocol": "tcp",
                "rule_no": 100,
                "action": "allow",
                "cidr_block": "0.0.0.0/0",
                "from_port": 0,
                "to_port": 65535,
            },
        },

    // private nacl egress rules | add rules in map blocks
    "nacl_private_egress": []map[string]interface{}{
            {
                "protocol": "tcp",
                "rule_no": 100,
                "action": "allow",
                "cidr_block": "0.0.0.0/0",
                "from_port": 0,
                "to_port": 65535,
            },
        },

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
		deployUsingTerraform(t, workingDir, awsRegion, awsProfile, vpcInputs)
	})


    /* 
    #####################################
    #            Validations            #
    #####################################
    */

	// validate EC2 names
	// test_structure.RunTestStage(t, "validate", func() {
	// 	validateEC2Names(t, workingDir, awsRegion, vpcInputs)
	// })
}


// terraform destroy
func destroyTerraform(t *testing.T, workingDir string) {
	// load the terraform options saved by the earlier deploy stage
	terraformOptions := test_structure.LoadTerraformOptions(t, "./")
	terraform.Destroy(t, terraformOptions)
}

func deployUsingTerraform(t *testing.T, workingDir string, awsRegion string, awsProfile string, vpcInputs map[string]interface{}) {

	// terraformOptions := &terraform.Options{
    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

        // the path to where the module code is located
        TerraformDir: workingDir,

        Vars: map[string]interface{}{
            "infra_region": vpcInputs["infra_region"],
            "infra_env": vpcInputs["infra_env"],
            "project_name": vpcInputs["project_name"],
            "secret_create": vpcInputs["secret_create"],
            "vpc_cidr_block": vpcInputs["vpc_cidr_block"],
            "public_subnet_numbers": vpcInputs["public_subnet_numbers"],
            "private_subnet_numbers": vpcInputs["private_subnet_numbers"],
            "bits_for_subnet_cidr": vpcInputs["bits_for_subnet_cidr"],
            "nacl_public_egress": vpcInputs["nacl_public_egress"],
            "nacl_public_ingress": vpcInputs["nacl_public_ingress"],
            "nacl_private_egress": vpcInputs["nacl_private_egress"],
            "nacl_private_ingress": vpcInputs["nacl_public_ingress"],
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

