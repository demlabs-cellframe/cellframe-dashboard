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
   echo "deploy_files.sh: copy files over ssh to registered servers"
   echo "Usage: deploy_files.sh SERVER PATH FILE1 FILE2 ... [--redirect-from PATH] "
   echo "options:   -r | --redirect-from=PATH will create a folder with JS redirect to deployed file"
   echo "options:   -j | --just-redirect will not copy files, just create redirection link"
   echo "options:   -l | --redirect-with-link=PATH will create a symlink to deployed file"
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
    -r|--redirect-from)
      REDIRECT="$2"
      shift # past argument
      shift # past value
      ;;
    -j|--just-redirect)
      NO_DEPLOY=1
      shift # past argument
      ;;
    -l|--redirect-with-link)
      REDIRECT_LINK="$2"
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

deploy_file()
{
    #find index of server in SERVERS
    for j in "${!SERVERS[@]}"; do
           [[ "${SERVERS[$j]}" = "${1}" ]] && break
    done

    SRV="${SERVERS[$j]}"
    KEY="${KEYS[$j]}"
    DPATH="${PATHS[$j]}"
    CRDT="${CREDS[$j]}"

    DEPLOY_SCP=(scp -i ${KEY} "${2}" ${CRDT}:${DPATH}/$3)
    DEPLOY_MKDIR=(ssh -i ${KEY} ${CRDT} mkdir -p ${DPATH}/$3)

    "${DEPLOY_MKDIR[@]}"
    "${DEPLOY_SCP[@]}"
}

create_redirect()
{
    #find index of server in SERVERS
    for j in "${!SERVERS[@]}"; do
           [[ "${SERVERS[$j]}" = "${1}" ]] && break
    done

    SRV="${SERVERS[$j]}"
    KEY="${KEYS[$j]}"
    DPATH="${PATHS[$j]}"
    CRDT="${CREDS[$j]}"

    REDIRECT_DIR=$4
    echo "$REDIRECT_DIR"

    REDIRECT_PATH_ON_SERVER=${DPATH}/${REDIRECT_DIR}
    FILE_PATH_ON_SERVER=${DPATH}/${3}/\"$(basename "$2")\"
    FILE_PATH_ON_SERVER_FOR_REDIRECT=${DPATH}/${3}/$(basename "$2")

    ssh -i ${KEY} -q ${CRDT} ls "${FILE_PATH_ON_SERVER}" && echo "File exists, creating pathes and redirect" ||  { echo "File does not exist";  exit 2; }

    RELATIVE_PATH_TO_FILE=$(realpath --canonicalize-missing --relative-to="$REDIRECT_PATH_ON_SERVER" "$FILE_PATH_ON_SERVER_FOR_REDIRECT")
    REDIRECT_SCRIPT="<script>window.onload = function(){document.location = '$RELATIVE_PATH_TO_FILE';}</script>"
    REDIRECT_SCRIPT_PATH="/tmp/redirect.html"
    echo "$REDIRECT_SCRIPT" > $REDIRECT_SCRIPT_PATH

    REDIRECT_MKDIR=(ssh -i ${KEY} ${CRDT} mkdir -p "${REDIRECT_PATH_ON_SERVER}")
    REDIRECT_SCP=(scp -i ${KEY} "$REDIRECT_SCRIPT_PATH" ${CRDT}:${REDIRECT_PATH_ON_SERVER}/index.html)

    "${REDIRECT_MKDIR[@]}"
    "${REDIRECT_SCP[@]}"

    rm $REDIRECT_SCRIPT_PATH
}

create_link()
{
    #find index of server in SERVERS
    for j in "${!SERVERS[@]}"; do
           [[ "${SERVERS[$j]}" = "${1}" ]] && break
    done

    SRV="${SERVERS[$j]}"
    KEY="${KEYS[$j]}"
    DPATH="${PATHS[$j]}"     
    CRDT="${CREDS[$j]}"

    REDIRECT_DIR=$4
    echo "$REDIRECT_DIR"

    REDIRECT_PATH_ON_SERVER=${DPATH}/${REDIRECT_DIR}
    FILE_ON_SERVER=$(basename "$2")
    FILE_PATH_ON_SERVER=${DPATH}/${3}/\"$(basename "$2")\"
    FILE_PATH_ON_SERVER_FOR_REDIRECT=${DPATH}/${3}/$(basename "$2")
    
    DEST_PATH_ON_SERVER=${REDIRECT_PATH_ON_SERVER%/*}
    RELEASE_TYPE=$(basename "$REDIRECT_DIR")
    
    ssh -i ${KEY} -q ${CRDT} ls "${FILE_PATH_ON_SERVER_FOR_REDIRECT}" && echo "File exists, creating symlink" ||  { echo "File does not exist";  exit 2; }

    # check if directory with JS link is present. If so, delete it before creating symlink.
    ssh -i ${KEY} -q ${CRDT} if test -d "${DEST_PATH_ON_SERVER}"/"${RELEASE_TYPE}"\; then rm -r "${DEST_PATH_ON_SERVER}"/"${RELEASE_TYPE}"\; fi

    LINK_CREATE=(ssh -i "${KEY}" -q "${CRDT}" "cd "${DEST_PATH_ON_SERVER}" && ln -sf ./"${FILE_ON_SERVER}" ./"${RELEASE_TYPE}"")

    "${LINK_CREATE[@]}"
}

echo "Files to deploy: [$FILES}]"
FILES_LENGTH=${#FILES[@]}

if [ $FILES_LENGTH -ne 1 ] && [ ! -z ${REDIRECT:+x} ]; then
    echo "Can't create redirect for multiple files, sorry....";
    exit 1;
fi

for (( i=1; i<${FILES_LENGTH}+1; i++ ));
do
   FILE="${FILES[$i-1]}"

    if [ -z ${NO_DEPLOY:+x} ]; then
        echo "Deploying [$FILE] to {${DST_SRV}:${DST_PATH}}..."
        deploy_file "${DST_SRV}" "${FILE}" "${DST_PATH}"
    fi

   if [ ! -z ${REDIRECT:+x} ]; then
        echo "Creating redirect to [$FILE] in [$REDIRECT] on [$DST_SRV]"
        create_redirect "${DST_SRV}" "${FILE}" "${DST_PATH}" "${REDIRECT}"
   fi

   if [ ! -z ${REDIRECT_LINK:+x} ]; then
        echo "Creating symlink to [$FILE] in [$DST_PATH] on [$DST_SRV]"
        create_link "${DST_SRV}" "${FILE}" "${DST_PATH}" "${REDIRECT_LINK}"
   fi
done
