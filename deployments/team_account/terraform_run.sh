#!/usr/bin/env bash

# array to query at end for any failures in child scripts
failed_file_array=()

# TODO make loop that checks for branch in subdirectories and fails and logs if not there

# if main branch will run all relevant child scripts and check outputs
if [[ $GIT_BRANCH == "origin/main" ]]; then

    # dev networking state file
    cd  dev/networking && ./networking_changes.sh
    if [[ $? -ne 0 ]]
    then
        failed_file_array+="origin/main networking failed"
    fi

# if dev branch will run all relevant child scripts and check outputs
elif [[ $GIT_BRANCH == "origin/dev" ]]; then

    # dev networking state file
    cd  dev/networking && ./networking_changes.sh
    if [[ $? -ne 0 ]]
    then
        failed_file_array+="origin/dev networking failed"
    fi

elif [[ $GIT_BRANCH == "origin/cloudwatch" ]]; then

    # dev networking state file
    cd  dev/networking && ./networking_changes.sh
    if [[ $? -ne 0 ]]
    then
        failed_file_array+="origin/dev networking failed"
    fi

else

    # if no branch match logs to cloudwatch and aborts Jenkins stage
    echo "ERROR NO BRANCH MATCH | Parent Bash Script For: $WORKSPACE $GIT_BRANCH `basename "$0"`"
    last_sequence_token=$(aws logs describe-log-streams --log-group-name SF_Terraform_Pipeline_Dev_Logs --query 'logStreams[?logStreamName ==`'SF_Terraform_Pipeline_ERROR'`].[uploadSequenceToken]' --output text)
    aws logs put-log-events \
        --log-group-name SF_Terraform_Pipeline_Dev_Logs \
        --log-stream-name SF_Terraform_Pipeline_ERROR \
        --log-events timestamp=$(date +%s%3N),message="ERROR NO BRANCH MATCH | In jenkins_run.sh Parent Bash Script For team_account: $GIT_BRANCH" \
        --sequence-token $last_sequence_token
    exit 1

fi

# checks if array has any "failed" entries | if so aborts Jenkins stage and sends cloudwatch log event
if [[ ${#failed_file_array[@]} -ne 0 ]]
then
    echo "ERROR IN CHILD SCRIPT | Child Bash Script For: ${failed_file_array[@]} $GIT_BRANCH `basename "$0"`"
    last_sequence_token=$(aws logs describe-log-streams --log-group-name SF_Terraform_Pipeline_Dev_Logs --query 'logStreams[?logStreamName ==`'SF_Terraform_Pipeline_ERROR'`].[uploadSequenceToken]' --output text)
    aws logs put-log-events \
        --log-group-name SF_Terraform_Pipeline_Dev_Logs \
        --log-stream-name SF_Terraform_Pipeline_ERROR \
        --log-events timestamp=$(date +%s%3N),message="ERROR IN CHILD SCRIPT | Child Bash Script For: ${failed_file_array[@]} $GIT_BRANCH `basename "$0"`" \
        --sequence-token $last_sequence_token
    exit 1
fi
