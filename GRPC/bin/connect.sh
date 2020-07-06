#!/usr/bin/env bash

source ./settings.sh

usage() {
    cat << USAGE >&2
Usage: bash ./bin/connect.sh CONTAINER [ COMMAND ]

	CONTAINER: List of acceptable Django Containers.
		delegator

	COMMAND: The command to be used when connecting to the container.
		By default, this is set to "/bin/bash".
USAGE
    exit 1
}

if [ "$1" == "" ]; then
	usage
fi

CONTAINER=""
COMMAND="/bin/bash"

case "$1" in
	"delegator")
		CONTAINER="gw-grpc_delegator"
		;;
	*)
		usage
		;;
esac

if [ "$2" != "" ]; then
	COMMAND="$2"
fi

DOCKER_COMMAND="""
docker-compose \
	--file ${GW_GRPC_DOCKER_COMPOSE_FILE} \
	-p ${PREFIX}-dev \
	exec \
	${CONTAINER} \
	${COMMAND}
"""

echo "Connecting to ${CONTAINER} service and running ${COMMAND} with command:"
echo ${DOCKER_COMMAND}
if [ "${TEST}" != "Y" ]; then
	eval ${DOCKER_COMMAND}
fi

# EXIT_SUCCESS
exit 0
