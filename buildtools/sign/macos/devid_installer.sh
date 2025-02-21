#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

OSX_CERTS_DIR=${CURRENT_DIR}/devid_installer/certs/
OSX_PKEY=${CURRENT_DIR}/devid_installer/devid_installer.p12
OSX_PKEY_PASS=4gCNlhOW13gK
