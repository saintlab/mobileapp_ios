#!/bin/sh

GIT_DIR=$(dirname $(pwd))
PROJECT_DIR="$GIT_DIR/iOS"

cd $GIT_DIR
echo "pull repo..."
#git pull origin master

type pod >/dev/null 2>&1 || {
echo >&2 "I require CocoaPods but it's not installed. Aborting.";
echo "to install run \"sudo gem install cocoapods\""
exit 1;
}

cd $PROJECT_DIR
#echo "install Pods..."
#pod update  2>&1  || { echo "pods doesn't install prorerly. Aborting."; exit 1;}

echo "check XCode..."
type xcodebuild >/dev/null 2>&1 || { echo >&2 "I require XCode but it's not installed.  Aborting."; exit 1; }

echo "build project..."

workspace="$PROJECT_DIR/Omnom.xcworkspace"

#killall -m -KILL "iPhone Simulator" || xcodebuild test \
#  -workspace $workspace \
#  -scheme "omnom" \
#  -configuration "Test" \
#  -destination 'platform=iOS Simulator,name=iPhone Retina (4-inch),OS=7.1'
#xcodebuild archive -workspace $workspace -archivePath "/Users/tea/Desktop/1/" -scheme "omnom"

#/usr/bin/xcrun -sdk iphoneos PackageApplication -v "/Users/tea/Desktop/1.xcarchive/Products/Applications/omnom.app" -o "Users/tea/Desktop/1/1.ipa" --sign "iPhone Distribution: EVGENIY TYUTYUEV (HJ648XXPWE)" --embed "/Users/tea/Documents/Projects/saintlab/mobileapp/sign/Omnom_AppStore.mobileprovision"
