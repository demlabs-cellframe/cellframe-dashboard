#!/bin/bash -e

set -e

if [ ${0:0:1} = "/" ]; then
	HERE=`dirname $0`
else
	CMD=`pwd`/$0
	HERE=`dirname ${CMD}`
fi

EXE_SIGN_POSSIBLE=1

if [ -z "$WIN_CERT_PATH" ]
then
	echo "No WIN_CERT_PATH provided. EXE will NOT be signed"
	EXE_SIGN_POSSIBLE=0
fi

if [ -z "$WIN_KEY_PATH" ]
then
	echo "No WIN_KEY_PATH provided. EXE will NOT be signed"
	EXE_SIGN_POSSIBLE=0
fi

if [ -z "$WIN_NAME" ]
then
	echo "No WIN_NAME provided. EXE will NOT be signed"
	EXE_SIGN_POSSIBLE=0
fi

if [ -z "$WIN_URL" ]
then
	echo "No WIN_URL provided. EXE will NOT be signed"
	EXE_SIGN_POSSIBLE=0
fi

PACK() 
{
    DIST_DIR=$1
    BUILD_DIR=$2
    OUT_DIR=$3
    ARCH=$(dpkg --print-architecture)
    source "${HERE}/../version.mk"
    PACKAGE_NAME="cellframe-dashboard_${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}_amd64.exe"
    PACKAGE_NAME_SIGNED="cellframe-dashboard_${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}_amd64-signed.exe"

    makensis ${DIST_DIR}/build.nsi
    mv ${DIST_DIR}/*installer.exe ${OUT_DIR}/${PACKAGE_NAME}

    if [ "$EXE_SIGN_POSSIBLE" -eq "1" ]; then
		echo "Signig $PACKAGE_NAME to $PACKAGE_NAME_SIGNED"

		cd ${OUT_DIR}
		
		osslsigncode sign -certs "${WIN_CERT_PATH}" -key "${WIN_KEY_PATH}" -n "${WIN_NAME}" -i "${WIN_URL}" -in "./${PACKAGE_NAME}" -out ./${PACKAGE_NAME_SIGNED}
		
        rm ${PACKAGE_NAME}
	fi
}
