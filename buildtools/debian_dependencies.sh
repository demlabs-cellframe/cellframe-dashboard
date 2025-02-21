#!/bin/bash
set -e

if [ ${0:0:1} = "/" ]; then
	HERE=`dirname $0`
else
	CMD=`pwd`/$0
	HERE=`dirname ${CMD}`
fi

BUILD_TOOLS_DEB_DEPENDENCIES="ssh python3-minimal python3-yaml"

echo "Updating package repository...."
apt-get update > /dev/null

echo "Installing [$BUILD_TOOLS_DEB_DEPENDENCIES] ... "
apt-get install $BUILD_TOOLS_DEB_DEPENDENCIES -y 

