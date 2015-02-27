#!/bin/bash

# This script generates changelog from last crashlytics upload,
# determined by "crashlytics-$UNIXTIME" tag.
#
# Lists entire repository log if no tag found
#
# Log format can be overriden via command line parameter:
#  ./crashlytics-changelog.sh "%H %s"
# See git help log / PRETTY FORMATS for placeholders reference.

set -e
set -u

LOG_FORMAT=${1:-"%ci: %H (%aN)%n * %s%n"}
LAST_TAG=$( git tag -l 'crashlytics-build-*' | sort | tail -1 )
LAST_TAG=${LAST_TAG:-$( git log --reverse --format=format:"%H" | head -1 )}

if [ "x" = "x$LAST_TAG" ]; then
    echo "Could not find previous tag"
    exit 1
fi

git log --format=format:"$LOG_FORMAT" $LAST_TAG..HEAD
