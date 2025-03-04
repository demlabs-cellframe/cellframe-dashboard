
#!/bin/bash -e

set -e

if [ ${0:0:1} = "/" ]; then
	HERE=`dirname $0`
else
	CMD=`pwd`/$0
	HERE=`dirname ${CMD}`
fi

#docker image already have this variables

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

#check if we can sign apk
APK_SIGN_POSSIBLE=1
if [ -z "$ANDROID_KEYSTORE_PATH" ]
then
      echo "No ANDROID_KEYSTORE_PATH provided. APK will NOT be signed"
      APK_SIGN_POSSIBLE=0
fi

if [ -z "$ANDROID_KEYSTORE_ALIAS" ]
then
      echo "No ANDROID_KEYSTORE_ALIAS provided. APK will NOT be signed"
      APK_SIGN_POSSIBLE=0
fi

if [ -z "$ANDROID_KEYSTORE_PASS" ]
then
      echo "No ANDROID_KEYSTORE_PASS provided. APK will NOT be signed"
      APK_SIGN_POSSIBLE=0
fi

echo "Using QT ${ANDROID_QT_VERSION} from ${ANDROID_QT_ROOT}/${ANDROID_QT_VERSION}"

[ ! -d ${ANDROID_QT_ROOT}/${ANDROID_QT_VERSION} ] && { echo "No QT ${ANDROID_QT_VERSION} found in ${ANDROID_QT_ROOT}" && exit 255; }

PACK() 
{
    BRAND="CellframeWallet"
    DIST_DIR=$1
    BUILD_DIR=$2
    OUT_DIR=$3

    SDK_VERSION=20

    #change SDK-version in manifest
    source "${SOURCES}/version.mk"

    echo "Changing targetSdkVersion in manifest to ${SDK_VERSION}"
    sed -i "s/android:targetSdkVersion=\"[0-9]\+\"/android:targetSdkVersion=\"$SDK_VERSION\"/g" ${DIST_DIR}/AndroidManifest.xml
    
    echo "Changing versionName in manifest to ${VERSION_MAJOR}.${VERSION_MINOR}-${VERSION_PATCH}"
    sed -i "s/android:versionName=\"[0-9]\+.[0-9]\+-[0-9]\+\"/android:versionName=\"${VERSION_MAJOR}.${VERSION_MINOR}-${VERSION_PATCH}\"/g" ${DIST_DIR}/AndroidManifest.xml
    
    VERSION_PATCH_LZERO=$(printf "%02d" ${VERSION_PATCH})
    echo "Changing versionCode in manifest to ${VERSION_MAJOR}${VERSION_MINOR}${VERSION_PATCH_LZERO}"
    sed -i "s/android:versionCode=\"[0-9]\+\"/android:versionCode=\"${VERSION_MAJOR}${VERSION_MINOR}${VERSION_PATCH_LZERO}\"/g" ${DIST_DIR}/AndroidManifest.xml

    echo "Building APK..."

    if [ "$APK_SIGN_POSSIBLE" -eq "1" ]; then
		QT_DEPLOY_SIGN_PARAMS="--sign ${ANDROID_KEYSTORE_PATH} ${ANDROID_KEYSTORE_ALIAS} --storepass  ${ANDROID_KEYSTORE_PASS}"
            QT_DEPLOY_APKNAME_PARAMS="--apk ${OUT_DIR}/${BRAND}-${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}.apk"
    else
            QT_DEPLOY_SIGN_PARAMS=""
            QT_DEPLOY_APKNAME_PARAMS="--apk ${OUT_DIR}/${BRAND}-${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}-unsigned.apk "
	fi


	echo "${ANDROID_QT_ROOT}/${ANDROID_QT_VERSION}/bin/androiddeployqt --output ${DIST_DIR} \
                                                                  --verbose \
                                                                  --release \
                                                                  --input ${BUILD_DIR}/CellFrameDashboard/*.json SIGN_PARAMS_HIDDEN ${QT_DEPLOY_APKNAME_PARAMS}"
																
	
	${ANDROID_QT_ROOT}/${ANDROID_QT_VERSION}/bin/androiddeployqt --output ${DIST_DIR} \
                                                                  --verbose \
                                                                  --release \
                                                                  --input ${BUILD_DIR}/CellFrameDashboard/*.json  \
																  ${QT_DEPLOY_SIGN_PARAMS} \
                                                                                                  ${QT_DEPLOY_APKNAME_PARAMS}
                                                     
}


