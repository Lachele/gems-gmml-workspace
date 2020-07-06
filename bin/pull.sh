#!/usr/bin/env bash

usage() {
	echo """

	bash ./bin/pull.sh

"""
	exit 1
}

source ./settings.sh
source ../etc/functions.sh

echo "Checking if it is safe to do a git pull."
if ! ( cd ${GW_DJANGO_DIR} && bash ./bin/do_fixture_management.sh ALL assess ); then
	print_error_and_exit "Like the script said... Something needs fixing. Exiting..."
fi

echo "Everything seems to be safe to do a git pull."
git pull

# EXIT_SUCCESS
exit 0
