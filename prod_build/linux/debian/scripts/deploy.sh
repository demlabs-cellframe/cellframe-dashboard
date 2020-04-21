#!/bin/bash

echo "Deploying to $PACKAGE_PATH"
pwd
cd build

PKGFILES=$(ls . | grep .deb | grep -v dbgsym)

[ ! $MOD = "" ] && MOD="-$MOD"
echo $PKGFILES

[[ $CI_COMMIT_REF_NAME == "master" ]] && scp -i $CELLFRAME_REPO_KEY ../prod_build/linux/$distro/scripts/publish_remote/reprepro.sh "$CELLFRAME_REPO_CREDS:~/tmp/" && scp -i $CELLFRAME_REPO_KEY ../prod_build/linux/$distro/scripts/publish_remote/reprepro.sh "$CELLFRAME_REPO_CREDS:~/tmp/"


for pkgfile in $PKGFILES; do
	pkgname=$(echo $pkgfile | sed "s/.deb$//")
	lnkname=$(echo $pkgname | sed "s/_${VERSION_STRING}//")
	echo "Symlink name is $lnkname"
	mv $pkgfile $wd/$PACKAGE_PATH/$pkgname$MOD.deb || echo "[ERR] Something went wrong in publishing the package. Now aborting."
	if [[ $CI_COMMIT_REF_NAME == "master" ]]; then #TMP restriction for master only.
		CODENAME=$(echo $pkgname | rev | cut -d '_' -f1 | rev)
		case "$distro" in
			"debian") section="non-free" ;;
			"ubuntu") section="multiverse" ;;
			*) ;;
		esac
			echo "attempting to publish cellframe-dashboard"
			scp -i $CELLFRAME_REPO_KEY $wd/$PACKAGE_PATH/$pkgname$MOD.deb "$CELLFRAME_REPO_CREDS:~/tmp/apt/"
			ssh -i $CELLFRAME_REPO_KEY "$CELLFRAME_REPO_CREDS" "chmod +x ~/tmp/reprepro.sh && ~/tmp/reprepro.sh $section $CODENAME ~/tmp/apt/$pkgname$MOD.deb $CELLFRAME_REPO_PATH" 
#			ssh "$CELLFRAME_REPO_CREDS" -- sudo reprepro -C "$DISTR_COMPONENT" --ask-passphrase includedeb "$DISTR_CODENAME" ##REPREPRO actions.
			scp -i $CELLFRAME_REPO_KEY $wd/$PACKAGE_PATH/$pkgname$MOD.deb "$CELLFRAME_FILESERVER_CREDS:~/web/pub.cellframe.net/public_html/linux/"
			ssh -i $CELLFRAME_REPO_KEY "$CELLFRAME_FILESERVER_CREDS" "ln -sf ~/web/pub.cellframe.net/public_html/linux/$pkgname$MOD.deb ~/web/pub.cellframe.net/public_html/linux/$lnkname$MOD-latest.deb"
	fi
#if [ ! -z $UPDVER ]; then
#	for pkgfile in $PKGFILES; do
		ln -sf $wd/$PACKAGE_PATH/$pkgname$MOD.deb $wd/$PACKAGE_PATH/$lnkname$MOD-latest.deb
#	done
	#Need to create latest symlink to the project.
#fi
done
[[ $CI_COMMIT_REF_NAME == "master" ]] && ssh -i $CELLFRAME_REPO_KEY "$CELLFRAME_REPO_CREDS" "rm -v ~/tmp/reprepro.sh" && ssh -i $CELLFRAME_REPO_KEY "$CELLFRAME_REPO_CREDS" "rm -v ~/tmp/reprepro.sh"
cd ..
#symlink name-actual to the latest version.
#build/deb/versions - for all files
#build/deb/${PROJECT}-latest - for symlinks.

