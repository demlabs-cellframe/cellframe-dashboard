#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

ANDROID_KEYSTORE_PATH=${CURRENT_DIR}/google-play-demlabs-key.jks
ANDROID_KEYSTORE_ALIAS=demlabskey
ANDROID_KEYSTORE_PASS=ugawabunga2008