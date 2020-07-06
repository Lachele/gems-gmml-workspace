#!/usr/bin/env bash

###
###  General Utilities
###

#  variable_is_empty VARIABLE
variable_is_empty() {
	if [ "${1}zzz" == "zzz" ] ; then
		true
	else
		false
	fi
}
# print_error_and_exit_failure [ ${ERROR} ]
print_error_and_exit() {
        if variable_is_empty ${1} ; then
		echo "There seems to have been a problem. See the output above for details. Exiting..."
	else
		echo "${1}"
	fi
	exit 1
}
# make a directory if it does not already exist
check_make_directory() {
	if variable_is_empty ${1} ; then
		print_error_and_exit "You must provide a directory name to check_make_directory."
	fi
	if [ -e ${1} ] && [ ! -d ${1} ] ; then
		print_error_and_exit "check_make_directory: Non-directory entity already exists with name ${1}."
	fi
	if [ ! -d ${1} ] ; then
		mkdir -p ${1}
	fi
}

###
###  Docker Utilities
###

# Simple function to check whether or not a specific Docker Image already exists.
# @param $1 The Docker Image
# @return boolean Returns 0(Success), if the Docker Image and Tag exist.
does_image_exist() {
	if [ "$( docker images --format {{.Repository}}:{{.Tag}} | grep -c ${1} )" -eq "0" ]; then
		return 1
	fi
	return 0
}
# is_container_running CONTAINER_NAME
is_container_running() {
	docker inspect --format '{{.State.Running}}' ${1}
}
# These two are super simple and will break if the grep gives stdout other than as expected
does_docker_service_exist() {
	OUTPUT=$(docker service list | grep ${1})
	if [ "${OUTPUT}zzz" == "zzz" ] ; then
		return 1
	else
		return 0
	fi
}
does_docker_stack_exist() {
	OUTPUT=$(docker stack list | grep ${1})
	if [ "${OUTPUT}zzz" == "zzz" ] ; then
		return 1
	else
		return 0
	fi
}
does_docker_compose_exist() {
	output=$(docker-compose --version 2>&1)
	if [[ ${output} == *"command not found"* ]] ; then
		return 1
	fi
	return 0
}
print_docker_compose_absent_swarm_and_exit() {
	echo """
Your system is in swarm mode and has requested a service provided by docker-compose.
However, docker-compose is not installed on this node.

Your options are to install docker-compose on this node (probably not the most desirable option)
or to ssh into a node that already has docker-compose installed and build the images there.

Exiting now.
	"""
	exit 1
}

# For SWARM MODE, see if the required image already exists in the repository
are_image_and_tag_in_repository() {
	if [ "${1}zzz" == "zzz" ] ; then
		echo "are_image_and_tag_in_repository requires two args: IMAGE and TAG. exiting"
		exit 1
	fi
	if [ "${2}zzz" == "zzz" ] ; then
		echo "are_image_and_tag_in_repository requires two args: image and TAG. exiting"
		exit 1
	fi
	if [ "${SWARM_REGISTRY}zzz" == "zzz" ] ; then
		echo "SWARM_REGISTRY is not defined.  
		The function is_image_in_repository should only be called in Swarm Mode.
		Esiting"
		exit 1
	else
		#echo "SWARM_REGISTRY is >>>${SWARM_REGISTRY}<<<"
		CURL_OUTPUT=$(curl http://${SWARM_REGISTRY}/v2/_catalog 2>/dev/null)
		if [[ ${CURL_OUTPUT} == *"${1}"* ]]; then
			CURL_OUTPUT=$(curl http://${SWARM_REGISTRY}/v2/${1}/tags/list 2>/dev/null)
			if [[ ${CURL_OUTPUT} == *"${2}"* ]]; then
				return 0
			else
				return 1
			fi
		else
			return 1
		fi
	fi
}



switch_start_type_if_in_swarm() {
	if [ "${SWARM}" == "true" ]; then
		COMMAND="bash ./bin/swarm-start.sh"
		#echo "In swarm mode, so calling swarm-start.sh"
		eval ${COMMAND}
		returnvalue=$?
		if [ "$?" != "0" ] ; then
			echo "Something went wrong with Swarm start.  See the logs."
		fi
		exit 0
	fi
}
switch_stop_type_if_in_swarm() {
	if [ "${SWARM}" == "true" ]; then
		COMMAND="bash ./bin/swarm-stop.sh ${1}"
		#echo "In swarm mode, so calling swarm-stop.sh"
		eval ${COMMAND}
		returnvalue=$?
		if [ "$?" != "0" ] ; then
			echo "Something went wrong with Swarm stop.  See the logs."
		fi
		exit 0
	fi
}

exit_if_stack_not_running() {
	if ! does_docker_stack_exist ${1} ; then
	print_error_and_exit "Something went wrong bringing up the ${1} stack.
	If there are logs listed below, see them for details.  Exiting.
	Possible Logs:
	    ${STDOUT_FILE}
	    ${STDERR_FILE}
	    "
	exit 1
fi

}
