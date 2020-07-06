#!/usr/bin/env bash

[ -n "${PROJECT_SETTINGS_SH}" ] && return || readonly PROJECT_SETTINGS_SH="SOURCED"
export TEST="N"


SWARM="false"
PREFIX="${USER}"
if [ "${PREFIX}zzz" == "zzz" ] ; then
	echo "PREFIX is not set.   Exiting"
	exit 1
fi
DOMAIN="localhost"
if [ -f LIVE_SWARM ] ; then
	SWARM="true"
	source LIVE_SWARM
fi
export SWARM_SLEEP='10'

export PREFIX
export DOMAIN
export SWARM
# In Docker Swarm, this would be done by the webdev user. In a developer environment, it will be the
# UID and GID of the local user running the script. This is to help with file permissions between host
# and containers.
export USER_UID="$( id -u )"
export USER_GID="$( id -g )"
export USER_NAME="$( id -un )"

# TODO Change this to include a list of the actual Docker Swarm Nodes.
# For example, webdev@howard, webdev@coleridge, webdev@parker
##  TODO - figure out if this is needed...
#export SWARM_NODES=(
#	'webdev@192.168.11.221'
#	'webdev@192.168.11.222'
#	'webdev@192.168.11.223'
#	'webdev@192.168.11.224'
#	'webdev@192.168.11.225'
#)
#export SWARM_NODES=(
#	'installer@192.168.1.80'
#	'installer@192.168.1.81'
#	'installer@192.168.1.82'
#	'installer@192.168.1.83'
#	'installer@192.168.1.84'
#)

#####################################
#    DevEnv Services Directories    #
#####################################
export GW_PROXY_DIR="./Proxy"
export GW_DJANGO_DIR="./Django"
export GW_WORDPRESS_DIR="./Wordpress"
export GW_SLURM_DIR="./Slurm"
export GW_GRPC_DIR="./GRPC"
export GW_VIRTUOSO_DIR="./Virtuoso"

#####################################
#	DevEnv Shared Directories		#
#####################################
export GW_PROGRAMS_DIR="./Web_Programs"
export GW_DATA_DIR="./Web_Data"

#####################################
#			DevEnv Messages			#
#####################################
export FILE_MESSAGE="""
# This file has been generated by a script. Do not edit the values here.
# If you need to change the values, then change them in their settings file.
# $( date )
"""

export FIXTURE_MANAGED_APPS_README_MESSAGE="""
This file serves two purposes:

1.  It lets the scripts know this DevEnv has been initialized
    to have the MariaDB tables for certain Django apps be automatically
    managed using Django's Fixtures feature.

    To learn more, see the docs here:
    http://128.192.9.183/eln/glycamweb/2018/08/31/scripts-for-django-database-management/

2.  It gives you an easy location for holding information about the
    automated management of these tables.

    Feel free to add more info here.  This file is not managed by git, and
    should not be overwritten by the other management scripts.

    That said...  if you put critical info here, keep a copy somewhere else.

If you delete this file, scripts will think you have not yet started to
    manage your DB data using fixtures.  Doing that hasn't been tested yet, so
    do so at your own risk.  But, you can probably recover from it.
"""

if [ -f ./LocalSettings.sh ]; then
	source ./LocalSettings.sh
fi
