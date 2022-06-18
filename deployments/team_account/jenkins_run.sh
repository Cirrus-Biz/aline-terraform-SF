#!/usr/bin/env bash

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

else

    echo "ERROR NO BRANCH MATCH TO: $GIT_BRANCH"
    last_sequence_token=$(aws logs describe-log-streams --log-group-name SF-Jenkins-Logs --query 'logStreams[?logStreamName ==`'Jenkins-Bash-Scripts'`].[uploadSequenceToken]' --output text)
    aws logs put-log-events \
        --log-group-name SF-Jenkins-Logs \
        --log-stream-name Jenkins-Bash-Scripts \
        --log-events timestamp=$(date +%s%3N),message="ERROR NO BRANCH MATCH TO: $GIT_BRANCH" \
        --sequence-token $last_sequence_token
    exit 1

fi

# checks all exit codes and if any failed will fail the stage of Jenkins pipeline
if [[ $main_networking == "failed" ]] || [[ $dev_networking == "failed" ]]
then
    exit 1
fi
