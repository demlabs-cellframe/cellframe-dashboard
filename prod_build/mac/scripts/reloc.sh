#!/bin/bash
#set up config

echo "Moving files"
pwd
mkdir -p "$APP_PATH/Contents/MacOS"

install_name_tool -delete_rpath $LIB_PATH $SRC_PATH/SapNetService/$APP_SERVICE_NAME
install_name_tool -add_rpath "@executable_path/../Frameworks" $SRC_PATH/SapNetService/$APP_SERVICE_NAME

if [ -e $(pwd)/SapNetService/$APP_SERVICE_NAME ]; then
    mv -f $(pwd)/SapNetService/$APP_SERVICE_NAME $APP_PATH/Contents/MacOS
fi

if [ -e $(pwd)/prod_build/mac/essentials/com.ncoded.UltraPadService.plist ]; then
    cp -f $(pwd)/prod_build/mac/essentials/com.ncoded.UltraPadService.plist $APP_PATH/Contents/Resources
fi

if [ -e $(pwd)/prod_build/mac/essentials/net.sf.tuntaposx.tun.plist ]; then
    cp -f $(pwd)/prod_build/mac/essentials/net.sf.tuntaposx.tun.plist $APP_PATH/Contents/Resources
    cp -rf $(pwd)/prod_build/mac/essentials/tun.kext $APP_PATH/Contents/Resources
fi

echo "[*] Relocate frameworks"
/usr/local/bin/osxrelocator -r $APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/Current/Libraries  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/
/usr/local/bin/osxrelocator -r $APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/Current/libexec  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/
/usr/local/bin/osxrelocator -r $APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/Current/bin  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/
/usr/local/bin/osxrelocator -r $APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/1.0/lib  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/
/usr/local/bin/osxrelocator -r $APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/1.0/libexec  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/
/usr/local/bin/osxrelocator -r $APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/1.0/bin  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/

/usr/local/bin/osxrelocator -r $APP_PATH/Contents/MacOS  /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/

/usr/local/bin/osxrelocator -r $APP_PATH/Contents/Frameworks @rpath @executable_path/../Frameworks 
/usr/local/bin/osxrelocator -r $APP_PATH/Contents/PlugIns @rpath @executable_path/../Frameworks
/usr/local/bin/osxrelocator -r $APP_PATH/Contents/MacOS @rpath @executable_path/../Frameworks

exit 0
