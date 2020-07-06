#!/usr/bin/env bash

# USAGE: bash ./bin/compile.sh [ OPTIONS ]
#
# OPTIONS:
# 		clean	Make sure to clean the repositories before compiling.

source ./settings.sh
source ./git-settings.sh
source ./etc/functions.sh
if [ ! -f ./ENVIRONMENT.sh ] ; then
	bash ./bin/set-environment.sh
fi
source ./ENVIRONMENT.sh

if [ ! -d ${GW_PROGRAMS_DIR}/${GEMS_DIR_NAME} ]; then
	print_error_and_exit "The GEMS directory seems to be missing. Please make sure to run git-setup.sh first. Exiting..."
fi
if [ ! -d ${GW_PROGRAMS_DIR}/${GEMS_DIR_NAME}/${GMML_DIR_NAME} ]; then
	print_error_and_exit "The GMML directory seems to be missing. Please make sure to run git-setup.sh first. Exiting..."
fi

cd ${GW_GRPC_DIR} && source ./settings.sh && cd ..

COMPILE_DOCKER_COMPOSE_FILE="./docker-compose.compile.yml"
GEMS_COMMAND="bash make.sh"
GPBUILDER_COMMAND="make"

# Do we need to clean?
i=1
while [ ${i} -le $# ]; do
	argument="${!i}"
	if [ "$argument" = "clean" ]; then
		GEMS_COMMAND="${GEMS_COMMAND} clean"
	        GPBUILDER_COMMAND="make clean && ${GPBUILDER_COMMAND}"
	elif [ "$argument" = "debug" ]; then 
		GEMS_COMMAND="${GEMS_COMMAND} debug"
	elif [ "$argument" = "no_wrap" ]; then
		GEMS_COMMAND="${GEMS_COMMAND} no_wrap"
	fi
	i=$[$i+1]
done

#if [ "${1}" == "clean" ]; then
#	GEMS_COMMAND="${GEMS_COMMAND} clean"
#	GPBUILDER_COMMAND="make clean && ${GPBUILDER_COMMAND}"
#fi

# First check to make sure the GRPC Delegator Docker Image is built.
# If not, we will just informt he user and exit.
if ! does_image_exist "${GW_GRPC_DELEGATOR_IMAGE}:${GW_GRPC_DELEGATOR_TAG}"; then
	print_error_and_exit "The GRPC Delegator Docker Image doesn't exist. Make sure to build it before compiling. Exiting..."
fi

# export these variables for docker-compose to know about them.
export GEMS_COMMAND
export GPBUILDER_COMMAND

# Second, run docker-compose up to compile everything.
COMMAND="docker-compose --file ${COMPILE_DOCKER_COMPOSE_FILE} up"
( cd ${GW_PROGRAMS_DIR} && ${COMMAND} | grep -i --color=always -e '^' -e 'error.*' | GREP_COLOR='01;35' grep -i --color=always -e '^' -e 'warning.*' | GREP_COLOR='01;36' grep -i --color=always -e '^' -e 'note.*')

# Third, once done compiling then run docker-compose down.
COMMAND="docker-compose --file ${COMPILE_DOCKER_COMPOSE_FILE} down"
( cd ${GW_PROGRAMS_DIR} && ${COMMAND} )

# EXIT_SUCCESS
exit 1
