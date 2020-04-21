#!/bin/bash
#set up config

echo "[!] Build source as application $APP_NAME ( $BUILD_PATH )"

echo "Qt path is on $QT_MAC_PATH with BRAND=$brand"
echo "j$(sysctl -a | egrep -i 'ncpu' | cut -d ' ' -f2)"

$QT_MAC_PATH/qmake *.pro -r -spec macx-clang CONFIG+=x86_64 BRAND=$brand BRAND_TARGET=$brand
make -j$(sysctl -a | egrep -i 'ncpu' | cut -d ' ' -f2)

exit 0
