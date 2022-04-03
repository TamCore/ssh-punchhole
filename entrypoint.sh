#!/bin/bash

set -x

_ssh="ssh -o StrictHostKeyChecking=yes -N -n -v "
_ssh+="-p ${SSH_PORT-22} -o IdentityFile=${IDENTITYFILE-/id_rsa} -o UserKnownHostsFile=${KNOWN_HOSTS-/known_hosts} "

IFS=' ' read -r -a REMOTE_FORWARD <<< "${REMOTE_FORWARD}"
IFS=' ' read -r -a LOCAL_DESTINATION <<< "${LOCAL_DESTINATION}"

len=${#REMOTE_FORWARD[@]}

for (( i=0; i<$len; i++ ))
do 
  remote=${REMOTE_FORWARD[$i]}
  local=${LOCAL_DESTINATION[$i]-${LOCAL_DESTINATION[0]}}

  echo "$remote -> $local"

  _ssh+="-R ${remote}:${local} "
done

_ssh+="${SSH_USER-root}@${REMOTE_HOST}"

${_ssh}

