#!/usr/bin/env bash

# date and time for logging
DATE=$(date +"%A-%D-%T-%Z")

# gets file path of this script
FILE_PATH=$(dirname "$(realpath $0)")

# init to correct state file
terraform init -backend-config=backend.hcl

# terraform plan that outputs plan to json file to be parsed
terraform plan -json -var-file=input.tfvars > tfplan_output.json

# greps plan output for errors
error_check=$(grep -o 'error' ./tfplan_output.json)

# check if grep for errors is empty
if [ -z "$error_check" ]

    # if no errors check for add/change/destroy values
    then
        # greps file for info we need
        plan_info=$(grep -o '"Plan: [0-9]* to add, [0-9]* to change, [0-9]* to destroy."' ./tfplan_output.json)

        # creates array of numbers for add/change/destroy
        plan_array=( $(echo $plan_info | grep -Eo '[0-9]+') )

        # sets each variable
        added=${plan_array[0]}
        changed=${plan_array[1]}
        destroyed=${plan_array[2]}

        # if all are 0 exports abort=true else apply and exports abort=false
        if [[ $added == 0 ]] && [[ $changed == 0 ]] && [[ $destroyed == 0 ]]
            then
                echo "0 added 0 changed 0 destroyed in `basename "$0"`| $DATE"
                last_sequence_token=$(aws logs describe-log-streams --log-group-name SF-Jenkins-Logs --query 'logStreams[?logStreamName ==`'Jenkins-Bash-Scripts'`].[uploadSequenceToken]' --output text)
                aws logs put-log-events \
                    --log-group-name SF-Jenkins-Logs \
                    --log-stream-name Jenkins-Bash-Scripts \
                    --log-events timestamp=$(date +%s%3N),message="NO APPLY IN: $GIT_BRANCH `basename "$0"`| $added added $changed changed $destroyed destroyed | $DATE" \
                    --sequence-token $last_sequence_token
            else
                echo "APPLIED PLAN | $added added $changed changed $destroyed destroyed | $DATE"
                last_sequence_token=$(aws logs describe-log-streams --log-group-name SF-Jenkins-Logs --query 'logStreams[?logStreamName ==`'Jenkins-Bash-Scripts'`].[uploadSequenceToken]' --output text)
                aws logs put-log-events \
                    --log-group-name SF-Jenkins-Logs \
                    --log-stream-name Jenkins-Bash-Scripts \
                    --log-events timestamp=$(date +%s%3N),message="APPLIED PLAN IN: $GIT_BRANCH `basename "$0"`| $added added $changed changed $destroyed destroyed | $DATE" \
                    --sequence-token $last_sequence_token
                # terraform apply -var-file=input.tfvars -auto-approve
        fi

    # if errors exports abort=true
    else
        echo "ERROR IN PLAN ABORTED | $DATE" >> ./change_log.txt
        echo "ERROR IN PLAN ABORTED | $DATE"
        exit 1
fi

