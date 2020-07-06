#!/usr/bin/env bash

source ./settings.sh
source ../etc/functions.sh

# If this is a swarm, so something different
switch_start_type_if_in_swarm

if [ "${SETUP}" != "YES" ]; then
	if ! bash ./bin/setup.sh; then
		print_error_and_exit
	fi
	export SETUP="YES"
fi

if [ "${BUILD}" != "YES" ]; then
	if ! bash ./bin/build.sh; then
		print_error_and_exit
	fi
	export BUILD="YES"
fi

DATE="$( date +%Y-%m-%d-%H-%M-%S )"
STDOUT_FILE="./logs/start_STDOUT_${DATE}.log"
STDERR_FILE="./logs/start_STDERR_${DATE}.log"

COMMAND="""
docker-compose \
	--file ${GW_GRPC_DOCKER_COMPOSE_FILE} \
	-p ${PREFIX}-dev \
	up -d \
	2>> ${STDERR_FILE} \
	>> ${STDOUT_FILE}
"""

echo ${COMMAND}
if [ "${TEST}" != "Y" ]; then
	eval ${COMMAND}
fi

# EXIT_SUCCESS
exit 0
