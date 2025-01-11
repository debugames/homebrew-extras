#!/usr/bin/env bash

# Create PR for bumping cask, and merge it if success

PACKAGE=$1 # <username>/<tapname>/<caskname>
VERSION=$2 # new version of the cask

brew bump-cask-pr $PACKAGE --no-fork --version $VERSION > tmp.log 2>&1
ret=$?
cat tmp.log
# If the command failed and the log contains 'Duplicate PRs must not be opened.', return 0
# Otherwise, return the error code
if [ $ret -ne 0 ]; then
  if grep -q "Duplicate PRs must not be opened." tmp.log; then
    echo "PR for $VERSION already exists. Skipping."
    exit 0
  else
    exit $ret
  fi
fi

# Find branch from the log and find PR number, then merge it
BRANCH=$(grep -oE "branch '[^']+" -m 1 tmp.log | sed "s/branch '//")
PR=$(gh pr list --head "$BRANCH" --json number --jq ".[0].number")
gh pr merge $PR --merge --delete-branch

exit 0
