cls

set ACOMPC=C:/Program Files/Adobe/Adobe Flash Builder 4.7 (64 Bit)/eclipse/plugins/com.adobe.flash.compiler_4.7.0.349722/AIRSDK/bin/acompc
set ADT=C:/Program Files/Adobe/Adobe Flash Builder 4.7 (64 Bit)/eclipse/plugins/com.adobe.flash.compiler_4.7.0.349722/AIRSDK/bin/adt
set UN_ZIP=./tools/unzip

set SWFVERSION=20

set INCLUDE_CLASSES="com.lj.ane.tesseract.TesseractANE"
set NAME=TesseractANE

echo "GENERATING SWC"
call "%ACOMPC%" -source-path flash/src/ -include-classes %INCLUDE_CLASSES% -swf-version=%SWFVERSION% -output %NAME%.swc

echo "GENERATING LIBRARY from SWC"
call "%UN_ZIP%" -o %NAME%.swc library.swf

copy /Y library.swf platform\\ios
copy /Y library.swf platform\\android
copy /Y library.swf platform\\default

del library.swf

echo "GETTING ANDROID JAR"
call "%UN_ZIP%" -o platform/android/tess-two-release.aar classes.jar -d platform/android/
rename platform\\android\\classes.jar tess-two.jar
call "%UN_ZIP%" -o platform/android/app-debug.aar classes.jar -d platform/android/

echo "GENERATING ANE"
call "%ADT%" -package -target ane %NAME%.ane extension.xml -swc %NAME%.swc ^
-platform iPhone-ARM -C platform/ios library.swf lib%NAME%.a -platformoptions platform/ios/platform.xml lib/libtesseract_all.a lib/liblept.a ^
-platform Android-ARM -C platform/android library.swf classes.jar libs/armeabi/libjpgt.so libs/armeabi/liblept.so libs/armeabi/libpngt.so libs/armeabi/libtess.so libs/armeabi-v7a/libjpgt.so libs/armeabi-v7a/liblept.so libs/armeabi-v7a/libpngt.so libs/armeabi-v7a/libtess.so -platformoptions platform/android/platform.xml tess-two.jar res/values/strings.xml ^
-platform default -C platform/default library.swf

del %NAME%.swc
del platform\\ios\\library.swf
del platform\\android\\library.swf
del platform\\android\\classes.jar
del platform\\android\\tess-two.jar
del platform\\default\\library.swf

echo "DONE!"