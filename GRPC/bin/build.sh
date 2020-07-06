#!/usr/bin/env bash

if [ "${BUILD}" == "YES" ]; then
	exit 0
fi

source ./settings.sh
source ../etc/functions.sh

if [ "${SETUP}" != "YES" ]; then
	if ! bash ./bin/setup.sh; then
		print_error_and_exit "Something happened when running the GRPC setup.sh script. Exiting..."
	fi
	export SETUP="YES"
fi

ImagesToBuild=()
DATE="$( date +%Y-%m-%d-%H-%M-%S )"

# Check if the GRPC Docker Images are already built or in the repo
if [ "${SWARM}" == "true" ] ; then
	numberabsent=0
	if ! are_image_and_tag_in_repository ${GW_GRPC_DELEGATOR_IMAGE_NOREPO} ${GW_GRPC_DELEGATOR_TAG} ; then
		numberabsent=$((numberabsent+1))
	fi
	if [ "${numberabsent}" -eq "0" ] ; then
		echo "The required images are all in the available repository.  Exiting build."
		exit 0
	elif ! does_docker_compose_exist ; then
		print_docker_compose_absent_swarm_and_exit
	fi
fi

# Check if the GRPC Docker Images are already built.
if ! does_image_exist "${GW_GRPC_DELEGATOR_IMAGE}:${GW_GRPC_DELEGATOR_TAG}"; then
	ImagesToBuild+=("gw-grpc_delegator")
fi

if [ "${#ImagesToBuild[@]}" != 0 ]; then
	STDERR_FILE="./logs/build_STDERR_${DATE}.log"
	STDOUT_FILE="./logs/build_STDOUT_${DATE}.log"
	DOCKER_COMMAND="""
docker-compose \
	--file ${GW_GRPC_DOCKER_COMPOSE_FILE} \
	-p ${PREFIX}-dev \
	build \
	--parallel \
	${ImagesToBuild[@]} \
	2>> ${STDERR_FILE} \
	>> ${STDOUT_FILE}
"""
	echo "Building Glycam Web GRPC Docker Images(${ImagesToBuild[@]}) on: $( hostname ) with command:"
	echo ${DOCKER_COMMAND}
	if [ "${TEST}" != "Y" ]; then
		eval ${DOCKER_COMMAND}
		if ! does_image_exist "${GW_GRPC_DELEGATOR_IMAGE}:${GW_GRPC_DELEGATOR_TAG}"; then
			print_error_and_exit "Something went wrong building the GRPC Docker Images. See ${STDERR_FILE} and/or ${STDOUT_FILE} for more information. Exiting..."
		fi
		if [ "${SWARM}" == "true" ] ; then
			bash bin/push.sh
		fi
	fi
else
	echo "All of the Glycam Web GRPC Docker Images are already built on your machine."
	if [ "${SWARM}" == "true" ] ; then
		bash bin/push.sh
	fi
fi

# EXIT_SUCCESS
exit 0
