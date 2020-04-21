#!/bin/bash

echo "packing things"

mkdir -p $wd/$BUILD_PATH

ls $wd
ls $wd/$BUILD_PATH
cp -r $APP_PATH $wd/$BUILD_PATH/

##### -- REMOVE AFTER VARIABLE SCOPE IS RIGHT -- #####
cd $wd/$SRC_PATH
. "$wd/$SRC_PATH/prod_build/general/pre-build.sh"
VERSION_INFO=$(extract_version_number)
cd $wd
##### -- PATCH_END -- #####

pkgbuild --analyze --root $wd/$BUILD_PATH/ $wd/$BUILD_PATH/$APP_NAME.plist

plutil -replace BundleIsRelocatable -bool NO $wd/$BUILD_PATH/$APP_NAME.plist

pkgbuild --install-location /Applications --identifier com.demlabs.$APP_NAME --scripts $wd/$SRC_PATH/$PKGSCRIPT_PATH --component-plist $wd/$BUILD_PATH/$APP_NAME.plist --root $wd/$BUILD_PATH/ $wd/$BUILD_PATH/$APP_NAME-$VERSION_INFO.pkg

#### For creating dmg
#macdeployqt $APP_PATH -verbose=2 -no-strip -no-plugins -dmg

#if [ -e $BUILD_PATH/SapNetGUI/$APP_NAME.dmg ]; then
#    mv -f $BUILD_PATH/SapNetGUI/$APP_NAME.dmg $BUILD_PATH
#    echo "[*] Success"
#else
#    echo "[ERR] Nothing was build examine build.log for details"
#    exit 2
#fi

exit 0
