#!/bin/bash

ACOMPC=/Users/vorlovsky/Documents/SDK/flex_sdk_4/bin/acompc
ADT=/Users/vorlovsky/Documents/SDK/AIRSDK_Compiler/bin/adt

SWFVERSION=20

INCLUDE_CLASSES="com.lj.ane.tesseract.TesseractANE"
NAME="TesseractANE"

cd /Users/vorlovsky/Dropbox/build

echo "GENERATING SWC"
$ACOMPC -source-path flash/src/ -include-classes $INCLUDE_CLASSES -swf-version=$SWFVERSION -output $NAME.swc

echo "GENERATING LIBRARY from SWC"
unzip -o $NAME.swc library.swf

cp library.swf platform/ios
cp library.swf platform/android
cp library.swf platform/default

rm -f library.swf

echo "GETTING ANDROID JAR"
unzip -o platform/android/tess-two-release.aar classes.jar -d platform/android/
mv platform/android/classes.jar platform/android/tess-two.jar
unzip -o platform/android/app-debug.aar classes.jar -d platform/android/

echo "GENERATING ANE"
$ADT -package -target ane $NAME.ane extension.xml -swc $NAME.swc -platform iPhone-ARM -C platform/ios library.swf lib@NAME.a -platformoptions platform/ios/platform.xml lib/libtesseract_all.a lib/liblept.a -platform Android-ARM -C platform/android library.swf classes.jar libs/armeabi/libjpgt.so libs/armeabi/liblept.so libs/armeabi/libpngt.so libs/armeabi/libtess.so libs/armeabi-v7a/libjpgt.so libs/armeabi-v7a/liblept.so libs/armeabi-v7a/libpngt.so libs/armeabi-v7a/libtess.so -platformoptions platform/android/platform.xml tess-two.jar res/values/strings.xml -platform default -C platform/default library.swf

rm -f @NAME.swc
rm -f platform/ios/library.swf
rm -f platform/android/library.swf
rm -f platform/android/classes.jar
rm -f platform/android/tess-two.jar
rm -f platform/default/library.swf

echo "DONE!"