#!/bin/bash

# By default fetch latest commit from upstream,
# or pick commit hash from command line

set -e
set -u

SCRIPT_DIR=$( cd $(dirname "$0") ; pwd -P )
INFOPLIST_FILE="$SCRIPT_DIR/../iOS/Omnom/Omnom/omnom-Info.plist"
CURRENT_BUILD_NUMBER=''

TAG_PREFIX='crashlytics-build'

COMMIT=${1:-$( git fetch && git log -1 --format=format:"%H" origin/master )}

if [ "x" = "x$COMMIT" ]; then
    echo "Could not find master commit hash"
    exit 1
fi

if ! git log -1 $COMMIT >/dev/null 2>&1; then
    echo "Commit $COMMIT not found in repo"
    exit 1
fi

TAG=$( git tag -l "$TAG_PREFIX-*" --points-at $COMMIT | wc -l )

if [ 0 -lt $TAG ]; then
    echo "Commit $COMMIT already tagged:"
    git tag -l "$TAG_PREFIX-*" --points-at $COMMIT
    exit 0
fi

PLIST_BUDDY='/usr/libexec/PlistBuddy'
if [ -e $PLIST_BUDDY ]; then
    CURRENT_BUILD_NUMBER=$( $PLIST_BUDDY -c "Print CFBundleVersion" "$INFOPLIST_FILE" )
    NEW_BUILD_NUMBER=$(( $CURRENT_BUILD_NUMBER + 1 ))
    $PLIST_BUDDY -c "Set :CFBundleVersion $NEW_BUILD_NUMBER" "$INFOPLIST_FILE"
    echo "Icreased version $CURRENT_BUILD_NUMBER -> $NEW_BUILD_NUMBER"
    git add $INFOPLIST_FILE
else
    CURRENT_BUILD_NUMBER=$( grep -A1 CFBundleVersion "$INFOPLIST_FILE" | tail -n1 | grep -oE '[0-9]+' )
    echo "No $PLIST_BUDDY found, will not increase version number in $INFOPLIST_FILE"
fi

git tag "$TAG_PREFIX-$CURRENT_BUILD_NUMBER" $COMMIT

echo ""
echo "Added $TAG_PREFIX-$CURRENT_BUILD_NUMBER tag to:"
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
