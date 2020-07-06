#!/bin/bash

## This file should be called from the directory above.

OUTFILE=ENVIRONMENT.sh

echo "#!/bin/bash
# Environment updated on:  $(date)
#" > ${OUTFILE}

DEV_ENV_BASE_PATH=$(pwd)
echo "
## The base of it all
export DEV_ENV_BASE_PATH=${DEV_ENV_BASE_PATH}
##
## Programs and data that get mounted to containers
export PROGRAMS_BASE_PATH=${DEV_ENV_BASE_PATH}/Web_Programs
export DATA_BASE_PATH=${DEV_ENV_BASE_PATH}/Web_Data
export GEMS_BASE_PATH=${DEV_ENV_BASE_PATH}/Web_Programs/gems
export USERDATA_BASE_PATH=${DEV_ENV_BASE_PATH}/Web_Data/userdata
export UPLOADS_BASE_PATH=${DEV_ENV_BASE_PATH}/Web_Data/uploads
##
## Build directories
export SLURM_BUILD_BASE_PATH=${DEV_ENV_BASE_PATH}/Slurm
export GRPC_BUILD_BASE_PATH=${DEV_ENV_BASE_PATH}/GRPC
export Django_BUILD_BASE_PATH=${DEV_ENV_BASE_PATH}/Django
export Wordpress_BUILD_BASE_PATH=${DEV_ENV_BASE_PATH}/Wordpress
export Proxy_BUILD_BASE_PATH=${DEV_ENV_BASE_PATH}/Proxy
export Virtuoso_BASE_PATH=${DEV_ENV_BASE_PATH}/Virtuoso
" >> ${OUTFILE}
