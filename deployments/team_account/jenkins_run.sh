#!/bin/bash

export GIT_BRANCH=$(${GIT_BRANCH})
echo "Git Branch = $GIT_BRANCH"

if [[ $GIT_BRANCH == "origin/dev" ]]
    then
        cd  dev/networking
        ./networking_changes.sh
        echo "NEW SCRIPT WORKED"
    else
        echo "NO BRANCH HERE"
fi
