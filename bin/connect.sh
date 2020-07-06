#!/usr/bin/env bash

source ./settings.sh

usage() {
    cat << USAGE >&2
Usage: bash ./bin/connect.sh SERVICE CONTAINER [ COMMAND ]

	SERVICE: List of acceptable Docker Services
		proxy
		django
		wordpress
		grpc
		slurm
		virtuoso

	CONTAINER: List of acceptable Containers by Docker Service.
		proxy
			nginx
		django
			nginx
			django
			mariadb
		wordpress
			nginx
		grpc
			delegator
		slurm
			head
			amber
			grafting
			autodocking
			other
		virtuoso
			virtuoso

	COMMAND: The command to be used when connecting to the container.
		By default, this is set to "/bin/bash".
USAGE
    exit 1
}

if [ "$1" == "" ] || [ "$2" == "" ]; then
	usage
fi

SERVICE="$1"
CONTAINER="$2"
COMMAND="/bin/bash"
SERVICE_DIRECTORY=""
if [ "$3" != "" ]; then
	COMMAND="$3"
fi

case "${SERVICE}" in
	"proxy")
		SERVICE_DIRECTORY="${GW_PROXY_DIR}"
		;;
	"django")
		SERVICE_DIRECTORY="${GW_DJANGO_DIR}"
		;;
	"wordpress")
		SERVICE_DIRECTORY="${GW_WORDPRESS_DIR}"
		;;
	"grpc")
		SERVICE_DIRECTORY="${GW_GRPC_DIR}"
		;;
	"slurm")
		SERVICE_DIRECTORY="${GW_SLURM_DIR}"
		;;
	"virtuoso")
		SERVICE_DIRECTORY="${GW_VIRTUOSO_DIR}"
		;;
	*)
		usage
		;;
esac

SCRIPT_COMMAND="( cd ${SERVICE_DIRECTORY} && bash ./bin/connect.sh ${CONTAINER} ${COMMAND} )"

echo ${SCRIPT_COMMAND}
if [ "${TEST}" != "Y" ]; then
	eval ${SCRIPT_COMMAND}
fi

# EXIT_SUCCESS
exit 0
