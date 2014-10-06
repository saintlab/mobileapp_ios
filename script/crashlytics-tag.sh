#!/bin/bash

# By default fetch latest commit from upstream,
# or pick commit hash from command line

set -e
set -u

COMMIT=${1:-$( git fetch && git log -1 --format=format:"%H" origin/master )}

if [ "x" = "x$COMMIT" ]; then
    echo "Could not find master commit hash"
    exit 1
fi

if ! git log -1 $COMMIT >/dev/null 2>&1; then
    echo "Commit $COMMIT not found in repo"
    exit 1
fi

TIMESTAMP=$( git log -1 --format=format:"%ct" $COMMIT )

if [ "x" = "x$TIMESTAMP" ]; then
    echo "Could not find master commit timestamp"
    exit 1
fi

TAG=$( git tag -l 'crashlytics-*' --points-at $COMMIT | wc -l )

if [ 0 -lt $TAG ]; then
    echo "Commit $COMMIT already tagged:"
    git tag -l 'crashlytics-*' --points-at $COMMIT
    exit 0
fi

git tag "crashlytics-$TIMESTAMP" $COMMIT

echo ""
echo "Added crashlytics-$TIMESTAMP tag to:"
echo ""
echo "-----------------------------------------------"
echo ""
git log -1 $COMMIT
echo ""
echo "-----------------------------------------------"
echo ""
echo "Do not forget to do"
echo ""
echo "    git push --tags"
echo ""
