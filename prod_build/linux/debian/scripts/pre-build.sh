#!/bin/bash

#export_variables() {

#IFS=$'\n'
#for variable in $(cat prod_build/linux/debian/conf/*); do
#	echo "$variable"
#	export $(echo "$variable" | sed 's/\"//g')
#done

#}


#installing required dependencies

check_packages() {

#	IFS=" "
	local PKG_DEPPIES=$(echo $PKG_DEPS | sed 's/\"//g')
	for element in "$PKG_DEPPIES"; do
		echo "[DEBUGGA] Checking if $element is installed"
		if ! dpkg-query -s $element; then 
			echo "[WRN] Package $element is not installed. Starting installation"
			return 1
		fi
	done
	return 0

}

install_dependencies() {

	echo "Checking out the dependencies"
	if check_packages >> /dev/null; then
		echo "[INF] All required packages are installed"
	else
		echo ""
		local PKG_DEPPIES=$(echo $PKG_DEPS | sed 's/\"//g')
		echo "[DEBUGGA] Attempting to install $PKG_DEPPIES"
		if sudo apt-get install $PKG_DEPPIES -y ; then
			echo ""
			echo "[INF] Packages were installed successfully"
		else
			echo "[ERR] can\'t install required packages. Please, check your package manager"
			echo "Aborting"
			exit 1
		fi
	fi
	return 0

}

#extract_version_number() {

#IFS=" "
#for entry in $VERSION_ENTRIES; do
#	VERSION_STRING=$(echo $VERSION_STRING | sed "s/$entry/$( cat $VERSION_FILE | grep $entry | sed 's/ //g' | cut -d '=' -f2 )/") #Replacing templates with numbers
#done
#echo -e "project version is $VERSION_STRING"
#
#}

#extract_gitlog_text() {
#
#borders=$( git log | grep -n 'commit\|Date' | head -n 3 | tail -n 2 | cut -d ':' -f1)
#upb=$(echo $borders | cut -d $'\n' -f1)
#dwnb=$(echo $borders | cut -d $'\n' -f2)
#text=$(git log | head -n $( expr $dwnb - 2 ) | tail -n $( expr $dwnb - $upb - 3 ) )
#echo $text
#
#}

#. prod_build/general/install_dependencies
. prod_build/general/pre-build.sh #VERSIONS and git
export_variables "prod_build/general/conf/*"
export_variables "prod_build/linux/debian/conf/*"

VERSION_STRING=$(echo $VERSION_FORMAT | sed "s/\"//g" ) #Removing quotes
VERSION_ENTRIES=$(echo $VERSION_ENTRIES | sed "s/\"//g" )
VERSION_STRING=$(extract_version_number)
last_version_string=$(cat prod_build/linux/debian/essentials/changelog | head -n 1 | cut -d '(' -f2 | cut -d ')' -f1)


#if [ $ONBUILDSERVER = 0 ]; then 
#	echo "[WRN] on build platform. Version won't be changed"

if [[ "$last_version_string" == "$VERSION_STRING" ]]; then
	echo "[INF] Version $last_version_string is equal to $VERSION_STRING. Nothing to change"
elif [ ! -e debian/changelog ]; then
	echo "[INF] debian/changelog does not exist. No need to change anything"
else
	echo "[INF] $VERSION_STRING is greater than $last_version_string"
	echo "[INF] editing the changelog"
	text=$(extract_gitlog_text)
	echo "text entry"
	echo "$text"
	echo  "End of text entry"
	IFS=$'\n'
	echo "VERSION_STRING = $VERSION_STRING"

	for textline in $text; do
		dch -v $VERSION_STRING $textline
	done
	branch=$(git branch | grep "*" | cut -c 3- )
	case branch in
		"master" ) branch="stable";;
		"develop" ) branch="testing";;
	esac
	dch -r --distribution "$branch" --force-distribution ignored
	controlfile_version=$(cat prod_build/linux/debian/essentials/control | grep "Standards" | cut -d ' ' -f2) #Add to control info.
	sed -i "s/$controlfile_version/$VERSION_STRING/" prod_build/linux/debian/essentials/control
	export UPDVER=1
fi

#Chrooted_environment tuning BEFORE building

echo "workdir is $(pwd)"
IFS=" "
CHROOT_PREFIX=$1
[[ $(echo "$MOD" | grep "static") != "" ]] && PKG_DEPS=$PKG_STATIC_DEPS
for distr in $HOST_DISTR_VERSIONS; do #we need to install required dependencies under schroot.
	for arch in $HOST_ARCH_VERSIONS; do
		echo "$CHROOT_PREFIX-$distr-$arch"
		schroot -c $CHROOT_PREFIX-$distr-$arch -- prod_build/linux/debian/scripts/chroot/pre-build.sh "$PKG_DEPS" || errcode=$?
		[[ $errcode != 0 ]] && echo "There are problems with $CHROOT_PREFIX-$distr-$arch. You had installed it, right?"
	done
done
exit 0
## Maybe we do have the version required? Then we don't need to build it again. CHECK IT THERE!
