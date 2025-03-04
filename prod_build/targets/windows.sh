
#!/bin/bash -e
#WINDWOS BUILD IS SUPPORTED BY MXE
#HAVE TO PROVIDE MXE ROOT DIRECTORY
set -e


if [ ${0:0:1} = "/" ]; then
	HERE=`dirname $0`
else
	CMD=`pwd`/$0
	HERE=`dirname ${CMD}`
fi


if [ -z "$MXE_ROOT" ]
then
      echo "Please, export MXE_ROOT variable, pointing to MXE environment root (we will use qt, make shure it was built)"
      echo "To build mxe, go to https://github.com/mxe/mxe, clone it, and do \"make qt5\" within it. Install dependencies if it says so." 
      exit 255
fi

#qmake command
QMAKE=(${MXE_ROOT}/usr/bin/x86_64-w64-mingw32.static-qmake-qt5)
export PATH=${MXE_ROOT}/usr/bin:$PATH
#everything else can be done by default make
MAKE=(make)

echo "Windows target"
echo "QMAKE=${QMAKE[@]}"
echo "MAKE=${MAKE[@]}"