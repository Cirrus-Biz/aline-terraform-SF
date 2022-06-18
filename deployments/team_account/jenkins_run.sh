#!/usr/bin/env bash

# if dev branch will run all relevant child scripts and check outputs
if [[ $GIT_BRANCH == "origin/dev" ]]
then

    # dev networking state file
    cd  dev/networking && ./networking_changes.sh
    if [[ $? -ne 0 ]]
    then
        dev_networking="failed"
    fi

fi


#something
# checks all exit codes and if any failed will fail the stage of Jenkins pipeline
if [[ $dev_networking == "failed" ]]
then
    exit 1
fi
