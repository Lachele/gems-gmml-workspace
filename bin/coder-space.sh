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

cd ${GW_GRPC_DIR} && source ./settings.sh && cd ..

COMPILE_DOCKER_COMPOSE_FILE="./docker-compose.compile.yml"

## These aren't needed, really, but defining them keeps us from 
## having to make a separate compose file
export GEMS_COMMAND="bash make.sh"
export GPBUILDER_COMMAND="make"

# First check to make sure the GRPC Delegator Docker Image is built.
# If not, we will just informt he user and exit.
if ! does_image_exist "${GW_GRPC_DELEGATOR_IMAGE}:${GW_GRPC_DELEGATOR_TAG}"; then
	print_error_and_exit "The GRPC Delegator Docker Image doesn't exist. Make sure to build it before compiling. Exiting..."
fi

# Second, run docker-compose up to compile everything.
COMMAND="docker-compose --file ${COMPILE_DOCKER_COMPOSE_FILE}   run  gw-grpc_compiler  bash"

echo "Starting a container for coding work with this command:
cd ${GW_PROGRAMS_DIR} && ${COMMAND}
"
( cd ${GW_PROGRAMS_DIR} && ${COMMAND} )

# EXIT_SUCCESS
exit 0
