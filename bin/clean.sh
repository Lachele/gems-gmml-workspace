#!/usr/bin/env bash

source ./settings.sh
source ./etc/functions.sh

# Call each Docker Services' clean.sh script.
echo "Removing the GRPC Docker Service setup files."
if ! ( cd ${GW_GRPC_DIR}	 	&& bash ./bin/clean.sh ); then
	print_error_and_exit
fi

# EXIT_SUCCESS
exit 0
