#!/bin/bash -e

set -e

if [ ${0:0:1} = "/" ]; then
	HERE=`dirname $0`
else
	CMD=`pwd`/$0
	HERE=`dirname ${CMD}`
fi


FILL_VERSION()
{
    source "${HERE}/../version.mk"

    VERSION_UPDATE="s|VERSION_MAJOR|${VERSION_MAJOR}|g"
    BUILD_UPDATE="s|VERSION_MINOR|${VERSION_MINOR}|g"
    MAJOR_UPDATE="s|VERSION_PATCH|${VERSION_PATCH}|g"

    for TEMPLATE in "$@"; do
        sed \
            -e "${VERSION_UPDATE}" \
            -e "${BUILD_UPDATE}" \
            -e "${MAJOR_UPDATE}" \
            -i "${TEMPLATE}"
    done
}

PACK() 
{
    
    DIST_DIR=$1
    BUILD_DIR=$2
    OUT_DIR=$3
    BUILD_TYPE=$4

    ARCH=$(dpkg --print-architecture)

    source "${HERE}/../version.mk"
    
    if [ "${BUILD_TYPE}" = "rwd" ]; then
        PACKAGE_NAME="cellframe-dashboard_${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}-rwd_${ARCH}.deb"
    else
        PACKAGE_NAME="cellframe-dashboard_${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}_${ARCH}.deb"
    fi

    mkdir -p ${DIST_DIR}/DEBIAN

    #dashboard pkg configs
    cp ${HERE}/../os/debian/control ${DIST_DIR}/DEBIAN
    cp ${HERE}/../os/debian/preinst ${DIST_DIR}/DEBIAN
    cp ${HERE}/../os/debian/postinst ${DIST_DIR}/DEBIAN
    cp ${HERE}/../os/debian/postrm  ${DIST_DIR}/DEBIAN
    
    FILL_VERSION ${DIST_DIR}/DEBIAN/control

    sed -i "s/{ARCH}/${ARCH}/g" ${DIST_DIR}/DEBIAN/control

    dpkg-deb --build ${DIST_DIR} ${OUT_DIR}/$PACKAGE_NAME
}
