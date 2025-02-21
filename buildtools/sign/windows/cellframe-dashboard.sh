#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

WIN_CERT_PATH=${CURRENT_DIR}/cellframe-dashboard/cert.pem
WIN_KEY_PATH=${CURRENT_DIR}/cellframe-dashboard/cert.key
WIN_NAME="Cellframe Dashboard"
WIN_URL="https://cellframe.net/"

