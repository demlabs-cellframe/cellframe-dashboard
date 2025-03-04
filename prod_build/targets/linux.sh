#!/bin/bash -e

set -e

if [ ${0:0:1} = "/" ]; then
	HERE=`dirname $0`
else
	CMD=`pwd`/$0
	HERE=`dirname ${CMD}`
fi


QMAKE=(qmake)
MAKE=(make)

echo "Linux target"
echo "QMAKE=${QMAKE[@]}"
echo "MAKE=${MAKE[@]}"