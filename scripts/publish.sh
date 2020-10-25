#!/bin/bash

set -e
cd "`dirname "$0"`/.." || exit

if [ "`git status -s`" ]
then
    echo "The working directory is dirty. You have uncommited changes."
    select yn in "Publish anyway" "Cancel"; do
        case "$yn" in
            "Cancel") exit 1 ;;
            *) break ;;
        esac
    done
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B master public origin/master

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating master branch"
cd public && git add --all && git commit -m "Publishing to master" --amend

echo "Pushing to github"
git push origin master --force
