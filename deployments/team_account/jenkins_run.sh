#!/usr/bin/env bash

if [[ $GIT_BRANCH == "origin/testing_jenkins" ]]

    cd  dev/networking && ./networking_changes.sh
    if [[ $? -ne 0 ]]; then
        dev_networking="failed"
    fi

fi

if [[ $dev_networking == "failed" ]]
    exit 1
fi
