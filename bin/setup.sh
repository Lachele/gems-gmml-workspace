#!/usr/bin/env bash

source ./settings.sh
source ./etc/functions.sh

echo "Making sure the Delegator Docker Service has what it needs."
if ! ( cd ${GW_GRPC_DIR}	 	&& bash ./bin/setup.sh ); then
	print_error_and_exit
fi

# EXIT_SUCCESS
exit 0
