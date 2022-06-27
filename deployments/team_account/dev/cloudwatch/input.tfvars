# project variables
infra_region = "us-east-1"
infra_env = "dev"
project_name = "aline-sf"

log_groups = ["SF_Test_Log_Group", "SF_Test_Log_Group_2"]

log_streams = {
                "sf_test_log_stream" = "SF_Test_Log_Group"
               }
