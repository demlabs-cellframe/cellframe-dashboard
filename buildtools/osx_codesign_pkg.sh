#!/bin/bash -e
set -e

if [ ${0:0:1} = "/" ]; then
	HERE=`dirname $0`
else
	CMD=`pwd`/$0
	HERE=`dirname ${CMD}`
fi

Help()
{
   echo "repack and sign osx .pkg installer"
   echo "Usage: osx_codesign_pkg.sh [--sign PATH] input.pkg output.pkg"
   echo "--sign PATH should provide a path to a signconfig file"
   echo "You need XAR & rcodesign from apple-codesign rust project"
}

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      Help
      shift # past argument
      shift # past value
      ;;
    -s|--sign)
      SIGNCONFIG="$2"
      shift # past argument
      shift # past value
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

#all base logic from here


SRC_PKG="${1}"
DST_PKG="$(basename ${SRC_PKG} .pkg)-signed.pkg"

if [ -z "$SIGNCONFIG" ]
then
      echo "No SIGNCONFIG provided. Packages will NOT be signed"
      exit 1      
else
  if [ -f "$SIGNCONFIG" ]
  then
    echo "Using sign-config from [${SIGNCONFIG}]"
    source $SIGNCONFIG
  else
    echo "[${SIGNCONFIG}] sign config not found"
    exit 255
  fi
fi


if [ -z "$SRC_PKG" ]
then
	Help
    exit 1
fi

if [ -z "$DST_PKG" ]
then
	Help
    exit 1
fi

echo "Sign & RePack [${SRC_PKG}] to [${DST_PKG}]"

PKG_SIGN_POSSIBLE=1

if [ -z "$OSX_PKEY_INSTALLER" ]
then
	echo "No OSX_PKEY_INSTALLER provided. PKG will NOT be signed"
	PKG_SIGN_POSSIBLE=0
fi

if [ -z "$OSX_PKEY_APPLICATION" ]
then
	echo "No OSX_PKEY_APPLICATION provided. PKG will NOT be signed"
	PKG_SIGN_POSSIBLE=0
fi

if [ -z "$OSX_PKEY_INSTALLER_PASS" ]
then
	echo "No OSX_PKEY_INSTALLER_PASS provided. PKG will NOT be signed"
	PKG_SIGN_POSSIBLE=0
fi

if [ -z "$OSX_PKEY_APPLICATION_PASS" ]
then
	echo "No OSX_PKEY_APPLICATION_PASS provided. PKG will NOT be signed"
	PKG_SIGN_POSSIBLE=0
fi

if [ -z "$OSX_APPSTORE_CONNECT_KEY" ]
then
	echo "No OSX_APPSTORE_CONNECT_KEY provided. PKG will NOT be signed"
	PKG_SIGN_POSSIBLE=0
fi


#1: exctract content of package to temporary dir
CWD=$PWD
TMP=${CWD}/tmpdir/
PAYLOAD=${TMP}/PayloadUNXAR

mkdir -p ${TMP}
mkdir -p ${PAYLOAD}

echo "Extracting app bundle to ${TMP}"

xar -C ${TMP} -xvf  ${SRC_PKG} 

echo "Extracting Payload ${TMP}"
cd ${PAYLOAD}
cat ${TMP}/Payload | gunzip -dc | cpio -i

cd ${TMP}

echo "Code-signig Payload"

#add runtime flag to bypass notarization warnings about hardened runtime.
rcodesign sign --code-signature-flags runtime \
                --p12-file ${OSX_PKEY_APPLICATION} \
                --p12-password ${OSX_PKEY_APPLICATION_PASS} \
                ${PAYLOAD}/*.app

echo "Re-pack BOM"
# create bom file
mkbom -u 0 -g 80 ${PAYLOAD} ${TMP}/Bom

# create Payload
echo "Re-pack Payload"
(cd ${PAYLOAD} && find . | cpio -o --format odc --owner 0:80 | gzip -c) > ${TMP}/Payload

rm -r ${PAYLOAD}

#update PkgInfo
echo "Update pkginfo"
numberOfFiles=$(find ${PAYLOAD_BUILD} | wc -l)
installKBytes=$(du -k -s ${PAYLOAD_BUILD} | cut -d"$(echo -e '\t')" -f1)
sed -i "s/numberOfFiles=\"[0-9]\+\"/numberOfFiles=\"$numberOfFiles\"/g" ${TMP}/PackageInfo
sed -i "s/installKBytes=\"[0-9]\+\"/installKBytes=\"$installKBytes\"/" ${TMP}/PackageInfo

(cd ${TMP} && xar --compression none -cf tmp.pkg *)

echo "Signig $DST_PKG with installer_id"

rcodesign sign --p12-file ${OSX_PKEY_INSTALLER} --p12-password ${OSX_PKEY_INSTALLER_PASS} tmp.pkg ${CWD}/${DST_PKG}
echo "Notarizing package"
rcodesign notary-submit --api-key-path ${OSX_APPSTORE_CONNECT_KEY} ${CWD}/${DST_PKG} --staple
rm tmp.pkg
rm -r ${TMP} 
echo "[$DST_PKG] Signed and notirized "
