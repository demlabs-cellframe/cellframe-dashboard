#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

ANDROID_KEYSTORE_PATH=${CURRENT_DIR}/ncoded.jks
ANDROID_KEYSTORE_ALIAS=ncoded
ANDROID_KEYSTORE_PASS=o9BWkoSb
