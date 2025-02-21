#!/bin/bash
set -e

if [ ${0:0:1} = "/" ]; then
	HERE=`dirname $0`
else
	CMD=`pwd`/$0
	HERE=`dirname ${CMD}`
fi

export TZ=Etc/UTC
export DEBIAN_FRONTEND=noninteractive

ARCH=${1:-default}
echo "Prepareing environment for [${ARCH}]"

echo "environment is $(uname -a)"

if [ "$ARCH" = "x86_64-apple-darvin" ]; then
	#we should be inside DOCKER-OSX container, and run the osx emulation
	${HERE}/run_osx_emulation.sh
else
	#debian based tools
	${HERE}/debian_dependencies.sh
fi


#here we should use a wrapper for commands, cause in OsX all work goes throug ssh

echo "Installing project dependencies for stage ${CI_JOB_STAGE}"
python3 ${HERE}/prepare_project.py install ${PWD}/project.yaml ${CI_JOB_STAGE} ${ARCH}