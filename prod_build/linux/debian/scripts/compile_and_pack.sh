#!/bin/bash

if [ "$1" == "--static" ]; then
	export $QT_SELECT="qtstatic" #For static builds we'll have a special qt instance, which should be installed manually for now, unfortunately.
fi

error_explainer() {

	case "$1" in
		"0"	) echo "";;
		"1"	) echo "Error in pre-config happened. Please, review logs";;
		"2"	) echo "Error in compilation happened. Please, review logs";;
		*	) echo "Unhandled error $1 happened. Please, review logs";;
	esac
}

cleanup () {

make distclean

if [ "$1" == "--static" ]; then
	export $QT_SELECT="default" #Returning back the shared library link
fi

}

error=0
#2DO: add trap command to clean the sources on exit.
trap cleanup SIGINT
dpkg-buildpackage -J -us --changes-option=--build=any -uc && mkdir -p build && mv ../*.deb build/ || error=$? 
cleanup
error_explainer $error
exit $error #2DO: Learn how to sign up the package.
