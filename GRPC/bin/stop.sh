#!/usr/bin/env bash

source ./settings.sh
source ../etc/functions.sh

# If in swarm, do something different
switch_stop_type_if_in_swarm

DATE="$( date +%Y-%m-%d-%H-%M-%S )"
STDERR_FILE="./logs/stop_STDERR_${DATE}.log"
STDOUT_FILE="./logs/stop_STDOUT_${DATE}.log"

COMMAND="""
docker-compose \
	--file ${GW_GRPC_DOCKER_COMPOSE_FILE} \
	-p ${PREFIX}-dev \
	down \
	2>> ${STDERR_FILE} \
	>> ${STDOUT_FILE}
"""

echo ${COMMAND}
if [ "${TEST}" != "Y" ]; then
	eval ${COMMAND}
fi

# EXIT_SUCCESS
exit 0
