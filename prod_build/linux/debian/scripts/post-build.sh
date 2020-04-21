#!/bin/bash

#echo "Stub for post-build actions"
echo "Entering post-build deployment and cleanup"
export distro=$(lsb_release -a 2>/dev/null | grep Distributor | cut -d $'\t' -f2 | tr '[:upper:]' '[:lower:]')
SCRIPTDIR="prod_build/linux/$distro/scripts"

$SCRIPTDIR/deploy.sh || exit 10 && \
$SCRIPTDIR/cleanup.sh || exit 11
