#!/bin/bash

# date for logging
DATE=$(date)

# set aws account to aline
export AWS_PROFILE=aline

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
                export ABORT="true"
                echo "aborted | 0 added 0 changed 0 destroyed | $DATE" >> ./change_log.txt
            else
                export ABORT="false"
                echo "applied plan | $added added $changed changed $destroyed destroyed | $DATE" >> ./change_log.txt
                # terraform apply -var-file=input.tfvars -auto-approve
        fi

    # if errors exports abort=true
    else
        export ABORT="true"
        echo "ERROR IN PLAN ABORTED | $DATE" >> ./change_log.txt
fi

# Jenkins will use export value to continue or abort pipeline