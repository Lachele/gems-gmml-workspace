#!/usr/bin/env bash

source ./settings.sh

# Get the IP Address of each Docker Container for this Docker Service.
COMMAND="docker inspect --format='{{(index .NetworkSettings.Networks \"${GW_GRPC_NETWORK}\" (index \"IPAddress\"))}}' ${GW_GRPC_DELEGATOR_CONTAINER_NAME}"
echo "GRPC/Delegator GRPC Network IP Address: $( eval ${COMMAND} )"

COMMAND="docker inspect --format='{{(index .NetworkSettings.Networks \"${GW_VIRTUOSO_NETWORK}\" (index \"IPAddress\"))}}' ${GW_GRPC_DELEGATOR_CONTAINER_NAME}"
echo "GRPC/Delegator Virtuoso Network IP Address: $( eval ${COMMAND} )"

COMMAND="docker inspect --format='{{(index .NetworkSettings.Networks \"${GW_SLURM_FRONTEND_NETWORK}\" (index \"IPAddress\"))}}' ${GW_GRPC_DELEGATOR_CONTAINER_NAME}"
echo "GRPC/Delegator Slurm Frontend Network IP Address: $( eval ${COMMAND} )"

# EXIT_SUCCESS
exit 0
