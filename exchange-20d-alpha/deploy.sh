#!/bin/bash

set -ex

# determine what stage is it?
# if running from Jenkins, you should use BRANCH_NAME env variable already available
# branch=$(git branch | grep "^*" | cut -f 2 -d ' ' | head -n 1)
branch=$BRANCH_NAME

# identify stage based on branch name
if [[ $branch == feature-* ]] 
then
    stage="dev"
elif [[ "$branch" == "master" ]]
then
    stage="staging"
elif [[ "$branch" == "production/deploy" ]]
then
    stage="prod"
fi

echo "Branch - $branch"
echo "Stage - $stage"

# build/push only if stage is dev or staging
if [[ "$stage" == "dev" ]] || [[ "$stage" == "staging" ]]
then
    pushd api
    make build stage=$stage
    make push stage=$stage
    popd

    pushd web
    make build stage=$stage
    make push stage=$stage
    popd
fi

pushd api
make deploy stage=$stage
popd
pushd web
make deploy stage=$stage
popd