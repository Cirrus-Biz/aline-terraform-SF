#!/usr/bin/env bash

# script is run by jenkins
# checks to make sure jenkins exported the git branch that initialized the webhook
# then builds an array of valid directory branch names in repo
# checks if the exported branch matches any directory name
# if it does cd's into that directory and runs tflint on all deployment directories in that branch
# finally it will check for any logged errors to failed_file_array
# if any failure logs to console, sends to cloudwatch logs, and exits with 1 to abort jenkins stage

export GIT_BRANCH="origin/dev"

# array to query at end for any failures
failed_file_array=()

# check if branch exported by jenkins is empty
if [[ -z "$GIT_BRANCH" ]]
then
    failed_file_array+="\$GIT_BRANCH NOT EXPORTED "
    GIT_BRANCH="BRANCH NOT EXPORTED"
else

    # loop over every subdirectory branch deployment names to build branch_subdirectories array
    branch_subdirectories=()
    for branch_dir in */
    do
        # check if branch_dir is directory
        if [[ -d "$branch_dir" ]]
        then
            branch_name=${branch_dir::-1}  # removes "/" at the end of branch_dir
            branch_subdirectories+=($branch_name)
        fi
    done

    # sets boolean branch_exists to true if directory maching GIT_BRANCH exists
    branch_exists=false
    for branch in "${branch_subdirectories[@]}"
    do
        if [[ "origin/$branch" == $GIT_BRANCH ]]
        then
            branch_exists=true
            branch_subdir=$branch
            break
        else
            continue
        fi
    done

    if [[ $branch_exists == false ]]
    then
        failed_file_array+="\$GIT_BRANCH DOES NOT MATCH A BRANCH DIRECTORY "
    else

        # cd into exported branch directory
        cd $branch_subdir

        # loop over every directory in branch deployment
        for dir in */
        do
            # check if dir is directory
            if [[ -d "$dir" ]]
            then
                cd $dir
                tflint
                if [[ $? -ne 0 ]]
                then
                    failed_file_array+="$dir "
                fi
                cd ..
            fi
        done
    fi

fi

# checks if array has any "failed" entries | if so aborts jenkins stage and sends cloudwatch log event
if [[ ${#failed_file_array[@]} -ne 0 ]]
then
    echo "ERROR TFLint | Linting Failed For Branch: $GIT_BRANCH | In Directories: ${failed_file_array[@]}| File: `basename "$0"`"
    # last_sequence_token=$(aws logs describe-log-streams --log-group-name SF_Terraform_Pipeline_Dev_Logs --query 'logStreams[?logStreamName ==`'SF_Terraform_Pipeline_ERROR'`].[uploadSequenceToken]' --output text)
    # aws logs put-log-events \
    #     --log-group-name SF_Terraform_Pipeline_Dev_Logs \
    #     --log-stream-name SF_Terraform_Pipeline_ERROR \
    #     --log-events timestamp=$(date +%s%3N),message="ERROR TFLint | Linting Failed For Branch: $GIT_BRANCH | In Directories: ${failed_file_array[@]}| File: `basename "$0"`" \
    #     --sequence-token $last_sequence_token
    exit 1
fi
