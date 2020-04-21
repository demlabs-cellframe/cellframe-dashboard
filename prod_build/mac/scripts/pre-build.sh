#!/bin/bash

#cp prod_build/mac/conf/PATHS prod_build/mac/conf/PATHS_TEMPLATE
sed -i.bak "s/BRAND/$brand/g" prod_build/mac/conf/PATHS
ls prod_build/mac/conf
cat prod_build/mac/conf/PATHS
