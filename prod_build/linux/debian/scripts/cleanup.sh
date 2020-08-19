#!/bin/bash

make distclean
rm -r prod_build/linux/debian/essentials/.debhelper/
rm prod_build/linux/debian/essentials/cellframe-dashboard.debhelper.log
rm prod_build/linux/debian/essentials/cellframe-dashboard.substvars
rm -r prod_build/linux/debian/essentials/cellframe-dashboard/
rm prod_build/linux/debian/essentials/files
