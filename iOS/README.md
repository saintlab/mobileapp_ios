mobileapp
=========

To start working on project run:
```
pod install
```
then run Omnom.xcworkspace

build job on jenkins
```
https://jenkins.saintlab.com/job/mobileapp_ios_crashlytics/
```
If job done and build upload to crashlytics run
```
script/crashlytics-tag.sh
git push --tags
```
