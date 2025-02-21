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
   echo "aptly_publish.sh: aptly repo publish"
   echo "Usage: aptly_publish.sh --repo reponame."
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

publish_repo()
{	
    #find index of server in SERVERS
    for j in "${!SERVERS[@]}"; do
           [[ "${SERVERS[$j]}" = "${1}" ]] && break
    done

    SRV="${SERVERS[$j]}"
    KEY="${KEYS[$j]}"
    DPATH="${PATHS[$j]}"
    CRDT="${CREDS[$j]}"
    
    UPDATE_CMD=(ssh -i ${KEY} ${CRDT}  "source .env && aptly publish update -force-overwrite -passphrase=\${APTLY_PASS} -batch main filesystem:${REPO}:public")
     
   "${UPDATE_CMD[@]}" 
}

echo "repo to publish: [${REPO}]"
FILES_LENGTH=${#FILES[@]}

if [ -z ${REPO:+x} ]; then
    echo "--repo is mandatory"
    exit 1
fi


publish_repo "${DST_SRV}" "${REPO}" 

