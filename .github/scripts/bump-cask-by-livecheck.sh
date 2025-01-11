#!/usr/bin/env bash

# Get latest version from livecheck, and bump cask

PACKAGE=$1 # <username>/<tapname>/<caskname>
VERSION=$(brew livecheck --json $PACKAGE | jq -r '.[0].version.latest')

if [ -z "$VERSION" ]; then
  echo "Failed to get latest version"
  exit 1
fi

.github/scripts/bump-cask.sh $PACKAGE $VERSION
