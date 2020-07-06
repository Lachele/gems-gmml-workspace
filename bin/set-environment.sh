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
export GEMS_BASE_PATH=${DEV_ENV_BASE_PATH}/Web_Programs/gems
##
## Build directories
export GRPC_BUILD_BASE_PATH=${DEV_ENV_BASE_PATH}/GRPC
" >> ${OUTFILE}
