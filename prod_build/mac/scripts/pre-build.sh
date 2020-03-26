#!/bin/bash
pwd

. prod_build/general/pre-build.sh
export VERSION_INFO=$(extract_version_number)
echo $VERSION_INFO
