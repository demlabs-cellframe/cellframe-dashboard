#!/bin/bash
#set up config

SIG_NAME="RM6P8427SY"

echo "--sign frameworks --"
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/GStreamer.framework/Versions/1.0/GStreamer
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/QtCore.framework/Versions/5/QtCore
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/QtDBus.framework/Versions/5/QtDBus
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/QtGui.framework/Versions/5/QtGui
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/QtOpenGL.framework/Versions/5/QtOpenGL
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/QtPrintSupport.framework/Versions/5/QtPrintSupport
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/QtNetwork.framework/Versions/5/QtNetwork
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/QtXml.framework/Versions/5/QtXml
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/QtQml.framework/Versions/5/QtQml
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/QtQuick.framework/Versions/5/QtQuick
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/QtQuickWidgets.framework/Versions/5/QtQuickWidgets
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/QtWidgets.framework/Versions/5/QtWidgets
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Frameworks/QtSvg.framework/Versions/5/QtSvg

echo "--sign plugins--"
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Plugins/bearer/libqcorewlanbearer.dylib
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Plugins/bearer/libqgenericbearer.dylib
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Plugins/platforms/libqcocoa.dylib
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Plugins/graphicssystems/libqtracegraphicssystem.dylib
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Plugins/imageformats/libqicns.dylib
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Plugins/imageformats/libqico.dylib
codesign --force --verify --verbose --sign "$SIG_NAME" $APP_PATH/Contents/Plugins/imageformats/libqjpeg.dylib

echo "--sign app--"
codesign --force --verify --deep --continue --verbose --sign "$SIG_NAME" $APP_PATH/Contents/MacOS/$APP_NAME
codesign --force --verify --deep --continue --verbose --sign "$SIG_NAME" $APP_PATH
exit 0
