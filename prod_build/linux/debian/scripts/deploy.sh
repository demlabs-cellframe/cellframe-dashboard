#!/bin/bash

echo "Deploying to $PACKAGE_PATH"
pwd
cd build
PKGFILES=$(ls . | grep .deb)

[ ! $MOD = "" ] && MOD="-$MOD"
echo $PKGFILES
for pkgfile in $PKGFILES; do
	pkgname=$(echo $pkgfile | sed "s/.deb$//")
	mv $pkgfile $wd/$PACKAGE_PATH/$pkgname$MOD.deb || echo "[ERR] Something went wrong in publishing the package. Now aborting."
if [ ! -z $UPDVER ]; then
#	for pkgfile in $PKGFILES; do
		ln -sf $wd/$PACKAGE_PATH/$pkgname$MOD.deb $wd/$PACKAGE_PATH/$pkgname$MOD-latest.deb
#	done
	#Need to create latest symlink to the project.
fi
done
	export -n "UPDVER"

cd ..
#symlink name-actual to the latest version.
#build/deb/versions - for all files
#build/deb/${PROJECT}-latest - for symlinks.
