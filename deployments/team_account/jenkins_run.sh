#!/usr/bin/env bash

# array to query at end for any failures in child scripts
failed_file_array=()

# if main branch will run all relevant child scripts and check outputs
if [[ $GIT_BRANCH == "origin/main" ]]; then

    # dev networking state file
    cd  dev/networking && ./networking_changes.sh
    if [[ $? -ne 0 ]]
    then
        main_networking="failed"
    fi

# if dev branch will run all relevant child scripts and check outputs
elif [[ $GIT_BRANCH == "origin/dev" ]]; then

    # dev networking state file
    cd  dev/networking && ./networking_changes.sh
    if [[ $? -ne 0 ]]
    then
        dev_networking="failed"
    fi

elif [[ $GIT_BRANCH == "origin/cloudwatch" ]]; then

    # dev networking state file
    cd  dev/networking && ./networking_changes.sh
    if [[ $? -ne 0 ]]
    then
        dev_networking="failed"
    fi

else

    # if no branch match logs to cloudwatch and aborts Jenkins stage
    echo "ERROR NO BRANCH MATCH | In jenkins_run.sh Parent Bash Script For team_account: $GIT_BRANCH"
    last_sequence_token=$(aws logs describe-log-streams --log-group-name SF-Jenkins-Logs --query 'logStreams[?logStreamName ==`'Jenkins-Bash-Scripts'`].[uploadSequenceToken]' --output text)
    aws logs put-log-events \
        --log-group-name SF-Jenkins-Logs \
        --log-stream-name Jenkins-Bash-Scripts \
        --log-events timestamp=$(date +%s%3N),message="ERROR NO BRANCH MATCH | In jenkins_run.sh Parent Bash Script For team_account: $GIT_BRANCH" \
        --sequence-token $last_sequence_token
    exit 1

fi

# checks if array has any "failed" entries | if so aborts Jenkins stage and sends cloudwatch log event
if [[ ${#test[@]} -ne 0 ]]
then
    echo "ERROR IN CHILD SCRIPT | Error in jenkins_run.sh Child Bash Script For team_account"
    last_sequence_token=$(aws logs describe-log-streams --log-group-name SF-Jenkins-Logs --query 'logStreams[?logStreamName ==`'Jenkins-Bash-Scripts'`].[uploadSequenceToken]' --output text)
    aws logs put-log-events \
        --log-group-name SF-Jenkins-Logs \
        --log-stream-name Jenkins-Bash-Scripts \
        --log-events timestamp=$(date +%s%3N),message="ERROR IN CHILD SCRIPT | Error in jenkins_run.sh Child Bash Script For team_account" \
        --sequence-token $last_sequence_token
    exit 1
fi
