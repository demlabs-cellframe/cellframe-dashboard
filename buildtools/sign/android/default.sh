#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

ANDROID_KEYSTORE_PATH=${CURRENT_DIR}/default-demlabs-key.jks
ANDROID_KEYSTORE_ALIAS=pconst
ANDROID_KEYSTORE_PASS=B0yc3-K0dd