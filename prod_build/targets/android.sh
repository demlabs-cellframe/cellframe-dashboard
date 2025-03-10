
#!/bin/bash -e
#ANDROID BUILD 
#HAVE TO PROVIDE ANDROID - QT ROOT & ANDROID QT VERSION 
set -e

if [ ${0:0:1} = "/" ]; then
	HERE=`dirname $0`
else
	CMD=`pwd`/$0
	HERE=`dirname ${CMD}`
fi


if [ -z "$ANDROID_QT_ROOT" ]
then
      echo "Please, export ANDROID_QT_ROOT variable, pointing to Qt-builds locations for android environment"
      exit 255
fi


if [ -z "$ANDROID_QT_VERSION" ]
then
      echo "Please, export ANDROID_QT_VERSION variable, scpecifying Qt-version in ANDROID_QT_ROOT directory."
      exit 255
fi

echo "Using QT ${ANDROID_QT_VERSION} from ${ANDROID_QT_ROOT}/${ANDROID_QT_VERSION}"

[ ! -d ${ANDROID_QT_ROOT}/${ANDROID_QT_VERSION} ] && { echo "No QT ${ANDROID_QT_VERSION} found in ${ANDROID_QT_ROOT}" && exit 255; }

if [ -z "$ANDROID_ABIS" ]
then
      ANDROID_ABIS="armeabi-v7a arm64-v8a x86_64"
     # ANDROID_ABIS="x86_64"
fi

#define QMAKE & MAKE commands for build.sh script
QMAKE=(${ANDROID_QT_ROOT}/${ANDROID_QT_VERSION}/bin/qmake -r BUILD_VARIANT=Default CONFIG+=qml_release ANDROID_ABIS="${ANDROID_ABIS}" )

#everything else can be done by default make
MAKE=(make)

echo "Android target"
echo "QMAKE=${QMAKE[@]}"
echo "MAKE=${MAKE[@]}"