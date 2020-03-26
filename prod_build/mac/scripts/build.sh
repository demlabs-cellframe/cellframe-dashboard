#!/bin/bash
#if [ -z "$1" ]; then
#    echo "[ERR] Script needs argument - package name. Use one of next :"
#    for i in `ls configs/build_dmg.pkg/| sed 's/\.cfg//'`; do
#	echo "      $i"
#    done
#    exit 1
#fi


./prod_build/mac/scripts/compile.sh $1 || exit 3
./prod_build/mac/scripts/deploy.sh $1 || exit 4
./prod_build/mac/scripts/reloc.sh $1 || exit 5
./prod_build/mac/scripts/sign.sh $1 || exit 6
./prod_build/mac/scripts/pack.sh $1 || exit 7

