#!/bin/bash
#set up config

echo "[*] Pack with $DEPLOY_OPTS"
macdeployqt $APP_PATH $DEPLOY_OPTS
#find $BUILD_PATH_FRAMEWORKS/GStreamer.framework  -path *.a -exec rm -rf {} \;
#find $BUILD_PATH_FRAMEWORKS/GStreamer.framework  -path *.la -exec rm -rf {} \;
#fdupes -r -dN $BUILD_PATH_FRAMEWORKS/GStreamer.framework/

exit 0
