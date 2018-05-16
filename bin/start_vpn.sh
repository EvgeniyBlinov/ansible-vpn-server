#!/bin/bash
SCRIPT_PATH=`dirname $0`
ABSOLUTE_PATH=`readlink -m ${SCRIPT_PATH}`
ROOT_PATH=`readlink -m ${ABSOLUTE_PATH}/..`

source $ROOT_PATH/.env

SUDO='sudo'

$SUDO /usr/sbin/openvpn \
    --config "${ROOT_PATH}/envs/${ANSIBLE_ENV}/.generated/client.ovpn"
