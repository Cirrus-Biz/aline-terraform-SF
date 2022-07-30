#!/usr/bin/env bash

export GIT_BRANCH=dev

cd $GIT_BRANCH

for dir in */
do
    if [ -d "$dir" ] && [ $dir == "jenkins_worker_ec2/" ]; then
        echo $dir
        cd $dir
        tflint
        cd ..
        pwd
    fi
done
