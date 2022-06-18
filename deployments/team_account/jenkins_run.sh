#!/usr/bin/env bash


if [[ $GIT_BRANCH == "origin/testing_jenkins" ]]
    then
        cd  dev/networking && ./networking_changes.sh
        if [[ $? -ne 0 ]]; then
            dev_networking=failed
        fi
    else
        echo "NO BRANCH HERE"
fi

if [[ $dev_networking == "failed" ]]
    exit 1
fi


