#!/usr/bin/env bash

[ -n "${GRPC_SETTINGS_SH}" ] && return || readonly GRPC_SETTINGS_SH="SOURCED"

cd ../
    source settings.sh
    source ENVIRONMENT.sh 
cd ${GW_GRPC_DIR}
cd ../Slurm 
    source settings.sh 
cd ../${GW_GRPC_DIR}
cd ../Virtuoso 
    source settings.sh 
cd ../${GW_GRPC_DIR}

GW_GRPC_SERVICE="gw-grpc"
GW_GRPC_DOCKER_COMPOSE_FILE="./docker-compose.grpc.yml"

IMAGES_PREFIX="${GW_GRPC_SERVICE}"
USER_IMAGES_PREFIX="${PREFIX}-${GW_GRPC_SERVICE}"
NOREPO_IMAGES_PREFIX="${GW_GRPC_SERVICE}"
NOREPO_USER_IMAGES_PREFIX="${PREFIX}-${GW_GRPC_SERVICE}"
CONTAINER_PREFIX=${USER_IMAGES_PREFIX}
NETWORK_PREFIX=${PREFIX}
if [ "$SWARM" == "true" ] ; then 
	IMAGES_PREFIX=${SWARM_REGISTRY}/${IMAGES_PREFIX}
	USER_IMAGES_PREFIX=${SWARM_REGISTRY}/${USER_IMAGES_PREFIX}
	NETWORK_PREFIX=${DEPLOY_DATE}_${PREFIX}
fi

#echo "swarm is >>${SWARM}<<"

#####################################
#  	GRPC Docker Images and Tags  	#
#####################################
export GW_GRPC_DELEGATOR_FROM_IMAGE="python:3.7.5-buster"
export GW_GRPC_DELEGATOR_BASE="delegator"
export GW_GRPC_DELEGATOR_IMAGE_NOREPO="${NOREPO_USER_IMAGES_PREFIX}-${GW_GRPC_DELEGATOR_BASE}"
export GW_GRPC_DELEGATOR_IMAGE="${USER_IMAGES_PREFIX}-${GW_GRPC_DELEGATOR_BASE}"
export GW_GRPC_DELEGATOR_TAG="1.0_blf_2020-02-26-00"

#echo "GW_GRPC_DELEGATOR_IMAGE is >>${GW_GRPC_DELEGATOR_IMAGE}<<"
#echo "GW_GRPC_DELEGATOR_TAG is >>${GW_GRPC_DELEGATOR_TAG}<<"

#####################################
# 	 GRPC Dockerfile Information  	#
#####################################
export GW_GRPC_DELEGATOR_DOCKERFILE_DIR="./images/delegator"
export GW_GRPC_DELEGATOR_DOCKERFILE="Dockerfile"

#####################################
# 	 GRPC Docker Container Names  	#
#####################################
export GW_GRPC_DELEGATOR_CONTAINER_NAME="${CONTAINER_PREFIX}_${GW_GRPC_DELEGATOR_BASE}"
#echo "GW_GRPC_DELEGATOR_CONTAINER_NAME is >>${CONTAINER_PREFIX}_${GW_GRPC_DELEGATOR_BASE}<<"

#####################################
#		GRPC Docker Networks		#
#####################################
export GW_GRPC_NETWORK="${NETWORK_PREFIX}_${GW_GRPC_SERVICE}-net"

#####################################
#  GRPC Docker Networks' Subnet		#
#####################################
export GW_GRPC_SUBNET=""

#####################################
#		GRPC Network Aliases		#
#####################################
export GW_GRPC_DELEGATOR_NET_ALIAS="gw-grpc_delegator"
export GW_GRPC_DELEGATOR_PORT="50051"

#####################################
#	  GRPC Environment Files		#
#####################################
export GW_GRPC_DELEGATOR_ENV_FILE="./env/delegator.env"

if [ -f ${GW_GRPC_DIR}/LocalSettings.sh ]; then
	source ${GW_GRPC_DIR}/LocalSettings.sh
fi
