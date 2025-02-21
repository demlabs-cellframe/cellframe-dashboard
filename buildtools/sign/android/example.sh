#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

ANDROID_KEYSTORE_PATH=${CURRENT_DIR}/example.jks
ANDROID_KEYSTORE_ALIAS=myalias
ANDROID_KEYSTORE_PASS=mypass