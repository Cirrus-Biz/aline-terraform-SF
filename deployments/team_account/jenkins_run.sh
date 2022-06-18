#!/usr/bin/env bash

# if dev branch will run all relevant child scripts and check outputs
if [[ $GIT_BRANCH == "origin/dev" ]]; then

    # dev networking state file
    cd  dev/networking && ./networking_changes.sh
    if [[ $? -ne 0 ]]
    then
        dev_networking="failed"
    fi
elif [[ $GIT_BRANCH == "origin/git_all_branch_webhook_test" ]]; then

    # dev networking state file
    cd  dev/networking && ./networking_changes.sh
    if [[ $? -ne 0 ]]
    then
        dev_networking="failed"
    fi

else
    echo "NO BRANCH MATCH"
    exit 1
fi


# checks all exit codes and if any failed will fail the stage of Jenkins pipeline
if [[ $dev_networking == "failed" ]]
then
    exit 1
fi
