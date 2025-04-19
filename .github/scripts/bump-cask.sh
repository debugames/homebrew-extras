#!/usr/bin/env bash

# Usage: bump-cask.sh <caskname> [version]

BREW_TAP_NAME="debugames/extras"

function main(){
  PACKAGE="$BREW_TAP_NAME/$1"
  VERSION=$2
  if [ -z "$VERSION" ]; then
    VERSION=$(brew livecheck --json "$PACKAGE" | jq -r '.[0].version.latest')
    if [ -z "$VERSION" ]; then
      echo "Failed to get latest version"
      exit 1
    fi
  fi
  create_merge_bump_pr "$PACKAGE" "$VERSION"
}

function create_merge_bump_pr() {
  PACKAGE=$1
  VERSION=$2
  brew bump-cask-pr "$PACKAGE" --no-fork --version "$VERSION" > tmp.log 2>&1 || ret=$?
  cat tmp.log
  # If the command-log includes specific message, return 0. Otherwise, return the error code
  if [ -n "$ret" ] && [ "$ret" -ne 0 ]; then
    if grep -q "Duplicate PRs must not be opened." tmp.log; then
      echo "PR for $VERSION already exists. Skipping."
      exit 0
    elif grep -q "nothing to commit, working tree clean" tmp.log; then
      echo "No changes (Maybe because this is the first PR for this cask)."
      exit 0
    fi
    exit "$ret"
  fi
  # Find branch from the log and find PR number, then merge it
  BRANCH=$(grep -oE "branch '[^']+" -m 1 tmp.log | sed "s/branch '//")
  PR=$(gh pr list --head "$BRANCH" --json number --jq ".[0].number")
  gh pr merge "$PR" --merge --delete-branch
}

main "$@"