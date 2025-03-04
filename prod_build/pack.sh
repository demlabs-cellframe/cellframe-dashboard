#!/bin/bash -e

set -e

if [ ${0:0:1} = "/" ]; then
	HERE=`dirname $0`
else
	CMD=`pwd`/$0
	HERE=`dirname ${CMD}`
fi

export SOURCES=${HERE}/../

NAME_OUT="$(uname -s)"
case "${NAME_OUT}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    MSYS_NT*)   MACHINE=Git;;
    *)          MACHINE="UNKNOWN:${NAME_OUT}"
esac



containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

Help()
{
   echo "cellframe-dashboard pack"
   echo "Usage: pack.sh [--target ${TARGETS}] [${BUILD_TYPES}]  [OPTIONS]"
   echo "--sign PATH should provide a path to file with env variables"
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
    -s|--sign)
      SIGNCONFIG="$2"
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

#all base logic from here
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

BUILD_TYPE="${1:-release}"
BUILD_OPTIONS="${@:2}"


#validate input params
. ${HERE}/validate.sh
VALIDATE_TARGET $TARGET
VALIDATE_BUILD_TYPE $BUILD_TYPE

DIST_DIR=${PWD}/build_${BUILD_TARGET}_${BUILD_TYPE}/dist
BUILD_DIR=${PWD}/build_${BUILD_TARGET}_${BUILD_TYPE}/build
OUT_DIR=${PWD}/build_${BUILD_TARGET}_${BUILD_TYPE}/

#we care only about dist dir, i think
[ ! -d ${DIST_DIR} ] && { echo "No build found: $BUILD_TARGET" && exit 255; }


if [ -z "$SIGNCONFIG" ]
then
      echo "No SIGNCONFIG provided. Packages will NOT be signed"
      
else
  if [ -f "$SIGNCONFIG" ]
  then
    echo "Using sign-config from [${SIGNCONFIG}]"
    source $SIGNCONFIG
  else
    echo "[${SIGNCONFIG}] sign config not found"
    exit 255
  fi
fi

echo "Pack [${BUILD_TYPE}] binaries for [$BUILD_TARGET] from [${DIST_DIR}] to [${OUT_DIR}]"

. ${HERE}/packaging/${BUILD_TARGET}.sh

PACK ${DIST_DIR} ${BUILD_DIR} ${OUT_DIR} ${BUILD_TYPE}



