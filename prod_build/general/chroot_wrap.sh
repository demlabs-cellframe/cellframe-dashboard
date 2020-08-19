#!/bin/bash


PLATFORM_CANDIDATES=$2
CHROOT_PREFIX="builder"
CHROOTS_PATH=$1
PLATFORMS=""
PKG_FORMAT=$3
JOB=$4

export wd=$(pwd)
cd $SRC_PATH
echo "workdir is $wd"
. prod_build/general/pre-build.sh
export_variables "./prod_build/general/conf/*"
. prod_build/general/mod-handler.sh
mod_handler $MOD

IFS=' '
echo "$PLATFORM_CANDIDATES"
echo $IMPLEMENTED

for platform in $PLATFORM_CANDIDATES; do
	[[ $(echo $IMPLEMENTED | grep $platform) != "" ]] && PLATFORMS="$PLATFORMS$platform " || echo "Platform $platform is not implemented in this project yet. Sorry"
done
[[ $PLATFORMS != "" ]] && PLATFORMS=$(echo $PLATFORMS | sed 's/ $//')
echo "Platforms are $PLATFORMS there"
[ -e "*.probak"] && rm "*.probak"

for platform in $PLATFORMS; do
	echo "Working with $platform now"
	PLATFORM_UPPERCASED=$( echo "$platform" | tr '[:lower:]' '[:upper:]')
	ENV=${PLATFORM_UPPERCASED}_ENV
	varpack=$(export | grep $PLATFORM_UPPERCASED | awk '{print $3}')
	[[ $platform == "linux" ]] && platform="linux/debian"
	export_variables "./prod_build/$platform/conf/*"
	IFS=' '
	PKG_TYPE=$(echo $PKG_FORMAT | cut -d ' ' -f1)
	#Check if chroots are present
	echo $HOST_DISTR_VERSIONS
	echo $HOST_ARCH_VERSIONS
	[ -e prod_build/$platform/scripts/pre-build.sh ] && prod_build/$platform/scripts/pre-build.sh $CHROOT_PREFIX || exit $? #For actions before build not in chroot and in chroot (version update, install missing dependencies(under schroot))
	for distr in $HOST_DISTR_VERSIONS; do
		for arch in $HOST_ARCH_VERSIONS; do
			if [ -e $CHROOTS_PATH/$CHROOT_PREFIX-$distr-$arch ]; then
set -x
				schroot -c $CHROOT_PREFIX-$distr-$arch -- launcher.sh prod_build/$platform/scripts/$JOB.sh $PKG_TYPE $platform $varpack || errcode=$?
set +x
#				echo "schroot stub $PKG_TYPE"
			else
				echo "chroot $CHROOT_PREFIX-$distr-$arch not found. You should install it first"
			fi
		done
	done
	echo "workdir before postinstall is $(pwd)"
	[ -e prod_build/$platform/scripts/post-build.sh ] && prod_build/$platform/scripts/post-build.sh #For post-build actions not in chroot (global publish)
	PKG_FORMAT=$(echo $PKG_FORMAT | cut -d ' ' -f2-)
	unexport_variables "./prod_build/$platform/conf/*"
done
#[ $(mount | grep "/run/schroot/mount") ] && sudo umount -l /run/schroot/mount && sudo rm -r /run/schroot/mount/* #Removing mountpoint odds.

cd $wd
