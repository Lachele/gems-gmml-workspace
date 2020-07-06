#!/usr/bin/env bash

echo "########################################################################"
echo "Updating the info about the local environment and loading settings."
if !  bash ./bin/set-environment.sh ; then
	echo "Cannot set the local environment.  Exiting."
	exit 1
fi
source ./settings.sh
source ./etc/functions.sh
echo "########################################################################"

# Building the Docker Images depends on the files the setup.sh script will create, so
# let us first call it to make sure these dependencies are met. This is mainly for when
# someone calls the build.sh script independently from the start.sh script or any other
# script. It is currently fine if the script which calls build.sh had previously called
# setup.sh.
if [ "${SETUP}" != "YES" ]; then
	if ! bash ./bin/setup.sh; then
		print_error_and_exit
	fi
	export SETUP="YES"
fi

echo "Building Delegator Docker Images."
if ! ( cd ${GW_GRPC_DIR} 		&& bash ./bin/build.sh ); then
	print_error_and_exit
fi

# EXIT_SUCCESS
exit 0
