#!/usr/bin/env bash

source ./settings.sh
source ./etc/functions.sh

# Call each Docker Services' clean.sh script.
echo "Removing the Virtuoso Docker Service setup files."
if ! ( cd ${GW_VIRTUOSO_DIR} 	&& bash ./bin/clean.sh ); then
	print_error_and_exit
fi
echo "Removing the Wordpress Docker Service setup files."
if ! ( cd ${GW_WORDPRESS_DIR} 	&& bash ./bin/clean.sh ); then
	print_error_and_exit
fi
echo "Removing the Proxy Docker Service setup files."
if ! ( cd ${GW_PROXY_DIR} 		&& bash ./bin/clean.sh ); then
	print_error_and_exit
fi
echo "Removing the Django Docker Service setup files."
if ! ( cd ${GW_DJANGO_DIR} 		&& bash ./bin/clean.sh ); then
	print_error_and_exit
fi
echo "Removing the GRPC Docker Service setup files."
if ! ( cd ${GW_GRPC_DIR}	 	&& bash ./bin/clean.sh ); then
	print_error_and_exit
fi
echo "Removing the Slurm Docker Service setup files."
if ! ( cd ${GW_SLURM_DIR} 		&& bash ./bin/clean.sh ); then
	print_error_and_exit
fi

# EXIT_SUCCESS
exit 0
