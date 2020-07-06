#!/usr/bin/env bash

source ./settings.sh
source ../etc/functions.sh

if [ "${SETUP}" != "YES" ]; then
	if ! bash ./bin/setup.sh; then
		print_error_and_exit "Something happened when running the Django setup.sh script. Exiting..."
	fi
	export SETUP="YES"
fi

ImagesToPush=()
NamesToCheck=()
TagsToCheck=()
DATE="$( date +%Y-%m-%d-%H-%M-%S )"

# Check to be sure the GRPC Docker Images are already built.
if ! does_image_exist "${GW_GRPC_DELEGATOR_IMAGE}:${GW_GRPC_DELEGATOR_TAG}"; then
	print_error_and_exit "gw_grpc_delegator is not built.  cannot push."
elif are_image_and_tag_in_repository ${GW_GRPC_DELEGATOR_IMAGE_NOREPO} ${GW_GRPC_DELEGATOR_TAG} ; then
	echo "${GW_GRPC_DELEGATOR_IMAGE}:${GW_GRPC_DELEGATOR_TAG} is already in repository.  Not pushing."
else
	ImagesToPush+=("gw-grpc_delegator")
	NamesToCheck+=("${GW_GRPC_DELEGATOR_IMAGE_NOREPO}")
	TagsToCheck+=("${GW_GRPC_DELEGATOR_TAG}")
fi

if [ "${#ImagesToPush[@]}" != "0" ]; then
	STDERR_FILE="./logs/push_STDERR_${DATE}.log"
	STDOUT_FILE="./logs/push_STDOUT_${DATE}.log"
	DOCKER_COMMAND="""
docker-compose \
	--file ${GW_GRPC_DOCKER_COMPOSE_FILE} \
	push \
	${ImagesToPush[@]} \
	2>> ${STDERR_FILE} \
	>> ${STDOUT_FILE}
"""
	echo "Pushing Glycam Web GRPC Docker Images(${ImagesToPush[@]}) to registry running on: $( hostname ) with command:"

	echo ${DOCKER_COMMAND}
	if [ "${TEST}" != "Y" ]; then
		eval ${DOCKER_COMMAND}
		i=0
		while [ "$i" -lt "${#NamesToCheck[@]}" ] ; do
			if ! are_image_and_tag_in_repository ${NamesToCheck[$i]} ${TagsToCheck[$i]} ; then
				echo "${NamesToCheck[$i]} ${TagsToCheck[$i]} did not get pushed to the repository.
				See these files for more info:  
				${STDERR_FILE} 
				${STDOUT_FILE}"
			fi
			i=$((i+1))
		done
	fi
else
	echo "Did not push any images."
fi

# EXIT_SUCCESS
exit 0
