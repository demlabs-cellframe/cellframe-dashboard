#!/bin/bash

DISTR_COMPONENT=$1
DISTR_CODENAME=$2
PKGNAME=$3
PATH=$4

workdir=$(pwd)
error=0
cd $PATH
reprepro -C "$DISTR_COMPONENT" --ask-passphrase includedeb "$DISTR_CODENAME" "$PKGNAME" && reprepro export "$DISTR_CODENAME" || error=$?
cd $workdir
exit $error
