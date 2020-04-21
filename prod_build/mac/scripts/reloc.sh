#!/bin/bash
#set up config

mkdir -p "$APP_PATH/Contents/MacOS"
if [ -e $wd/$SRC_PATH/DapChainVpnService/$APP_SERVICE_NAME ]; then
    mv -f $wd/$SRC_PATH/DapChainVpnService/$APP_SERVICE_NAME $wd/$SRC_PATH/$APP_PATH/Contents/MacOS
 fi

echo "It is a $brand"
if [ -e $wd/$SRC_PATH/prod_build/mac/essentials/com.*.${brand}Service.plist ]; then
	cp -f $wd/$SRC_PATH/prod_build/mac/essentials/com.*.${brand}Service.plist $wd/$SRC_PATH/$APP_PATH/Contents/Resources/
fi

if [ -e $wd/$SRC_PATH/prod_build/mac/essentials/cleanup ]; then
	cp -rf $wd/$SRC_PATH/prod_build/mac/essentials/cleanup $wd/$SRC_PATH/$APP_PATH/Contents/Resources/
fi

if [ -e $wd/$SRC_PATH/prod_build/mac/essentials/net.sf.tuntaposx.tun.plist ]; then
    cp -f $wd/$SRC_PATH/prod_build/mac/essentials/net.sf.tuntaposx.tun.plist $wd/$SRC_PATH/$APP_PATH/Contents/Resources/
fi

if [ -e $wd/$SRC_PATH/prod_build/mac/essentials/tun.kext ]; then
    cp -rf $wd/$SRC_PATH/prod_build/mac/essentials/tun.kext $wd/$SRC_PATH/$APP_PATH/Contents/Resources/
fi



echo "[*] Relocate frameworks"
/usr/local/bin/osxrelocator -r $wd/$SRC_PATH/$APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/Current/Libraries  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/
/usr/local/bin/osxrelocator -r $wd/$SRC_PATH/$APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/Current/libexec  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/
/usr/local/bin/osxrelocator -r $wd/$SRC_PATH/$APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/Current/bin  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/
/usr/local/bin/osxrelocator -r $wd/$SRC_PATH/$APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/1.0/lib  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/
/usr/local/bin/osxrelocator -r $wd/$SRC_PATH/$APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/1.0/libexec  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/
/usr/local/bin/osxrelocator -r $wd/$SRC_PATH/$APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/1.0/bin  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/

/usr/local/bin/osxrelocator -r $wd/$SRC_PATH/$APP_PATH/Contents/MacOS  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/

/usr/local/bin/osxrelocator -r $wd/$SRC_PATH/$APP_PATH/Contents/Frameworks @rpath @executable_path/../Frameworks
/usr/local/bin/osxrelocator -r $wd/$SRC_PATH/$APP_PATH/Contents/MacOS @rpath @executable_path/../Frameworks
/usr/local/bin/osxrelocator -r $wd/$SRC_PATH/$APP_PATH/Contents/PlugIns @rpath @executable_path/../Frameworks

exit 0
