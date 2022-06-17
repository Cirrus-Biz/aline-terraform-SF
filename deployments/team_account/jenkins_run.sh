#!/bin/bash

git_branch=$(${GIT_BRANCH})
echo $git_branch

if [[ $git_branch == dev ]]
    then
        cd  dev/networking
        ./networking_changes.sh
        echo "NEW SCRIPT WORKED"
    else
        echo "NO BRANCH HERE"
fi
