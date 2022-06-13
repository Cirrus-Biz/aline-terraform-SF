#!/bin/bash

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
            else
                # terraform plan -var-file=input.tfvars
                # terraform apply -var-file=input.tfvars -auto-approve
                export ABORT="false"
        fi

    # if errors exports abort=true
    else
        export ABORT="true"
fi

# Jenkins will use export value to continue or abort
echo $ABORT
