#!/bin/bash
set -e

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  TARGET=$(readlink "$SOURCE")
  if [[ $TARGET == /* ]]; then
    echo "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'"
    SOURCE=$TARGET
  else
    DIR=$( dirname "$SOURCE" )
    echo "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')"
    SOURCE=$DIR/$TARGET # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  fi
done
echo "SOURCE is '$SOURCE'"
RDIR=$( dirname "$SOURCE" )
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
MHERE="$DIR"


export SOURCES=${MHERE}/../

NAME_OUT="$(uname -s)"
case "${NAME_OUT}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    MSYS_NT*)   MACHINE=Git;;
    *)          MACHINE="UNKNOWN:${NAME_OUT}"
esac



#validate input params
. ${MHERE}/validate.sh

Help()
{
   echo "cellframe-wallet build"
   echo "Usage: build.sh [--target ${TARGETS}] [${BUILD_TYPES}]  [OPTIONS]"
   echo "options:   -DWHATEVER=ANYTHING will be passed to cmake as defines"
   echo
}

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      Help
      shift # past argument
      shift # past value
      ;;
    -t|--target)
      TARGET="$2"
      shift # past argument
      shift # past value
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

BUILD_TYPE="${1:-release}"
BUILD_OPTIONS="${@:2}"


DEFAULT_TARGET="linux"
if [ "$MACHINE" == "Mac" ]
then
  DEFAULT_TARGET="osx"
fi

if [ "$MACHINE" == "Linux" ]
then
  DEFAULT_TARGET="linux"
fi

if [ "$MACHINE" == "Git" ]
then
  DEFAULT_TARGET="windows"
fi

if [ "$MACHINE" == "MinGw" ]
then
  DEFAULT_TARGET="windows"
fi

echo "Host machin is $MACHINE"
BUILD_TARGET="${TARGET:-$DEFAULT_TARGET}"

BUILD_DIR=${PWD}/build_${BUILD_TARGET}_${BUILD_TYPE}

VALIDATE_TARGET $TARGET
VALIDATE_BUILD_TYPE $BUILD_TYPE

#append qmake debug\release qmake options for this
if [ "${BUILD_TYPE}" = "debug" ]; then
    BUILD_OPTIONS[${#BUILD_OPTIONS[@]}]="CONFIG+=debug"
elif [ "${BUILD_TYPE}" = "rwd" ]; then
    BUILD_OPTIONS[${#BUILD_OPTIONS[@]}]="CONFIG+=force_debug_info"
else
    BUILD_OPTIONS[${#BUILD_OPTIONS[@]}]="CONFIG+=release"
fi

. ${HERE}/targets/${BUILD_TARGET}.sh

#all base logic from here
mkdir -p ${BUILD_DIR}/build
mkdir -p ${BUILD_DIR}/dist

if [ "$MACHINE" != "Mac" ]
then
  NPROC="$(nproc)"
else
  NPROC="$(sysctl -n hw.ncpu)"
fi

echo "Build [${BUILD_TYPE}] binaries for [$BUILD_TARGET] in [${BUILD_DIR}] on $NPROC threads"
echo "with options: [${BUILD_OPTIONS[@]}]"

cd ${BUILD_DIR}/build

#this will install all to DIST folder for futher packaging
export INSTALL_ROOT=${BUILD_DIR}/dist
echo "$MHERE"
"${QMAKE[@]}" $MHERE/../*.pro  ${BUILD_OPTIONS[@]}
"${MAKE[@]}" -j4
"${MAKE[@]}" install
