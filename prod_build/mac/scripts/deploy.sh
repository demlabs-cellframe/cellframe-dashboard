#!/bin/bash
echo "Deploying the mac app"
pwd
$QT_MAC_PATH/macdeployqt SapNetGui/$BRAND.app -verbose=3 -always-overwrite
