#!/bin/bash
set -e

if [ ${0:0:1} = "/" ]; then
    HERE=`dirname $0`
else
    CMD=`pwd`/$0
    HERE=`dirname ${CMD}`
fi

Help()
{
   echo "aptly_publish.sh: all aptly repo add and aptly publish over remote server"
   echo "Usage: aptly_publish.sh SERVER PACKAGE1 PACKAGE2 ..."
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

    -r|--repo)
      REPO="$2"
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

DST_SRV=$1
DST_PATH=$2
declare -a FILES=("${@:3}")
echo $FILES
. ${HERE}/config.sh

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

containsElement "${DST_SRV}" "${SERVERS[@]}"  || {
    echo "Such deploy server not implemented [$DST_SRV]"
    echo "Available servers are [${SERVERS[@]}]"
    exit 255
}

publish_file()
{	
    #find index of server in SERVERS
    for j in "${!SERVERS[@]}"; do
           [[ "${SERVERS[$j]}" = "${1}" ]] && break
    done

    SRV="${SERVERS[$j]}"
    KEY="${KEYS[$j]}"
    DPATH="${PATHS[$j]}"
    CRDT="${CREDS[$j]}"
    
    PUBLISH_CMD=(ssh -i ${KEY} ${CRDT} "source .env && aptly repo add --force-replace ${REPO} ${DPATH}/$3/$(basename $2)")
    UPDATE_CMD=(ssh -i ${KEY} ${CRDT} "source .env && aptly publish update -passphrase=\${APTLY_PASS} main filesystem:${REPO}:public")
     
   "${PUBLISH_CMD[@]}"
   #echo  "${UPDATE_CMD[@]}" 
}

echo "Files to publish: [${FILES}]"
FILES_LENGTH=${#FILES[@]}

if [ -z ${REPO:+x} ]; then
    echo "--repo is mandatory"
    exit 1
fi

for (( i=1; i<${FILES_LENGTH}+1; i++ ));
do
   FILE="${FILES[$i-1]}"
   
    echo "Try add [$FILE] from {${DST_SRV}:${DST_PATH}}..."
    publish_file "${DST_SRV}" "${FILE}" "${DST_PATH}"

done

