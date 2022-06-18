#!/usr/bin/env bash


if [[ $GIT_BRANCH == "origin/testing_jenkins" ]]
    then
        cd  dev/networking && ./networking_changes.sh

        if [ $? -eq 0 ]; then
            echo "built"
        else
            exit 1
        fi

        echo "NEW SCRIPT WORKED"
    else
        echo "NO BRANCH HERE"
fi


