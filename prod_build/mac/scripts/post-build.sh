#!/bin/bash

echo "VERSION_INFO"
export -n VERSION_INFO

deploy.sh || exit $?
make distclean
mv prod_build/mac/conf/PATHS.bak prod_build/mac/conf/PATHS
