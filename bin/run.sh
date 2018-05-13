#!/bin/bash
SCRIPT_PATH=`dirname $0`
ABSOLUTE_PATH=`readlink -m ${SCRIPT_PATH}`
ROOT_PATH=`readlink -m ${ABSOLUTE_PATH}/..`
PLAYBOOK_NAME="$1"

source $ROOT_PATH/.env

(
cd $ROOT_PATH &&
time \
    env $(cat .env|grep -iv '^[^a-z]'|xargs) \
    ansible-playbook \
    -i envs/${ANSIBLE_ENV}/hosts.yml \
    $PLAYBOOK_NAME && \
    echo "END"
)
    #--vault-password-file "${PASSWORD_KEY}" \
