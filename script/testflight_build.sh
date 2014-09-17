#!/bin/sh

GIT_DIR=$(dirname $(pwd))
PROJECT_DIR="$GIT_DIR/iOS"

cd $GIT_DIR
echo "pull repo..."
git pull origin master

type pod >/dev/null 2>&1 || {
echo >&2 "I require CocoaPods but it's not installed. Aborting.";
echo "to install run \"sudo gem install cocoapods\""
exit 1;
}

cd $PROJECT_DIR
echo "install Pods..."
pod install  2>&1  || { echo "pods doesn't install prorerly. Aborting."; exit 1;}

echo "check XCode..."
type xcodebuild >/dev/null 2>&1 || { echo >&2 "I require XCode but it's not installed.  Aborting."; exit 1; }

echo "build project..."

WORKSPACE_NAME="Omnom"
APPNAME="omnom"
CONFIG="Ad-Hoc"
SDK="iphoneos"
WORKSPACE="$PROJECT_DIR/$WORKSPACE_NAME.xcworkspace"
BUILDDIR="$TMPDIR/build$TARGET"
OUTPUTDIR="$BUILDDIR/$CONFIG-$SDK"
DEVELOPER_NAME="iPhone Developer: Eugene Tutuev (YT796UPAG9)"
PROVISIONING_PROFILE="$GIT_DIR/sign/sainlab_wildcard.mobileprovision"

echo "$BUILDDIR"

echo "Cleaning..."
xcodebuild -alltargets clean

echo "Building..."
xcodebuild  \
  -workspace "$WORKSPACE" \
  -scheme "omnom" \
  -sdk "$SDK" \
  -configuration "$CONFIG" \
  OBJROOT="$BUILDDIR" \
  SYMROOT="$BUILDDIR"

echo "Signing..."
xcrun \
  -log \
  -sdk iphoneos \
  PackageApplication \
  -v "$OUTPUTDIR/$APPNAME.app" \
  -o "$OUTPUTDIR/$APPNAME.ipa" \
  -sign "$DEVELOPER_NAME" \
  -embed "$PROVISIONING_PROFILE"


