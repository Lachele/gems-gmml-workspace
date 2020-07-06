#!/usr/bin/env bash

if [ "${SETUP}" == "YES" ]; then
	exit 0
fi

source ./settings.sh
source ../etc/functions.sh

#########################################
#		     Ensure Directories				#
#########################################
DelegatorDirectories=(
	./env/
	./logs/
	)
for directory in ${DelegatorDirectories[@]} ; do
	check_make_directory ${directory}
done

#########################################
#			Delegator Setup				#
#########################################
echo """${FILE_MESSAGE}
GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
""" > ${GW_GRPC_DELEGATOR_ENV_FILE}

# EXIT_SUCESS
exit 0
