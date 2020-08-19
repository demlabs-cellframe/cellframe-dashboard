#!/bin/bash

WORKDIR="resources/cellframe/cellframe-dashboard"
SCRIPTDIR="prod_build/linux/debian/scripts"
PLATFORM=$2
shift 2

for var in $@; do
	export ${var//\"/}
done

#cd $WORKDIR
	$SCRIPTDIR/compile_and_pack.sh || exit 12 && \
	$SCRIPTDIR/test.sh || exit 13 && \
	$SCRIPTDIR/install_test.sh || exit 14 && \
	$SCRIPTDIR/cleanup.sh || exit 15
#cd $wd
