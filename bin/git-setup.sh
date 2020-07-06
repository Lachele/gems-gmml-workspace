#!/usr/bin/env bash

source ./settings.sh
source ./git-settings.sh
source ./etc/functions.sh

# Check if Web_Programs directory exist.
if [ ! -d ${GW_RPOGRAMS_DIR} ]; then
	print_error_and_exit "The Glycam Web Programs Directory seems to be missing. Exiting..."
fi

# Check if GEMS directory exist.
NEWGEMS="NO"
if [ ! -d ${GW_PROGRAMS_DIR}/${GEMS_DIR_NAME} ]; then
	echo "didn't find ${GW_PROGRAMS_DIR}/${GEMS_DIR_NAME}"
	NEWGEMS="YES"
	COMMAND="( cd ${GW_PROGRAMS_DIR} && ${GEMS_CLONE_COMMAND} )"
	echo ${COMMAND}
	if [ "${TEST}" != "Y" ]; then
		eval ${COMMAND}
		if [ ! -d ${GW_PROGRAMS_DIR}/${GEMS_DIR_NAME} ]; then
			print_error_and_exit "Unable yto clone GEMS repo. Exiting..."
		fi
	fi
fi
# Check if GMML directory exist.
NEWGMML="NO"
if [ ! -d ${GW_PROGRAMS_DIR}/${GEMS_DIR_NAME}/${GMML_DIR_NAME} ]; then
	echo "didn't find ${GW_PROGRAMS_DIR}/${GEMS_DIR_NAME}/${GMML_DIR_NAME}"
	NEWGMML="YES"
	COMMAND="( cd ${GW_PROGRAMS_DIR}/${GEMS_DIR_NAME} && ${GMML_CLONE_COMMAND} )"
	echo ${COMMAND}
	if [ "${TEST}" != "Y" ]; then
		eval ${COMMAND}
		if [ ! -d ${GW_PROGRAMS_DIR}/${GEMS_DIR_NAME}/${GMML_DIR_NAME} ]; then
			print_error_and_exit "Unable to clone GMML repo. Exiting..."
		fi
	fi
fi
# Check if GlycoProteinBuilder directory exist.
NEWGPBUILDER="NO"
if [ ! -d ${GW_PROGRAMS_DIR}/${GPBUILDER_DIR_NAME} ]; then
	echo "didn't find ${GW_PROGRAMS_DIR}/${GPBUILDER_DIR_NAME}"
	NEWGPBUILDER="YES"
	COMMAND="( cd ${GW_PROGRAMS_DIR} && ${GPBUILDER_CLONE_COMMAND} )"
	echo ${COMMAND}
	if [ "${TEST}" != "Y" ]; then
		eval ${COMMAND}
		if [ ! -d ${GW_PROGRAMS_DIR}/${GPBUILDER_DIR_NAME} ]; then
			print_error_and_exit "Unable to clone GlycoProteinBuilder repo. Exiting..."
		fi
	fi
fi
if [ "${NEWGEMS}" == "YES" ] && [ "${NEWGMML}" == "YES" ] && [ "${NEWGPBUILDER}" == "YES" ]; then
	echo "GEMS/GMML and GlycoProteinBuilder repos cloned successfully. Don't forget to compile!"
fi

# See if anything needs to be pulled.
if [ "${NEWGEMS}" == "NO" ]; then
	echo "Pulling new data into GEMS."
	COMMAND="( cd ${GW_PROGRAMS_DIR}/${GEMS_DIR_NAME} && ${GEMS_PULL_COMMAND} )"
	echo ${COMMAND}
	if [ "${TEST}" != "Y" ]; then
		eval ${COMMAND}
	fi
fi
if [ "${NEWGMML}" == "NO" ]; then
	echo "Pulling new data into GMML - don't forget to compile!"
	COMMAND="( cd ${GW_PROGRAMS_DIR}/${GEMS_DIR_NAME}/${GMML_DIR_NAME} && ${GMML_PULL_COMMAND} )"
	echo ${COMMAND}
	if [ "${TEST}" != "Y" ]; then
		eval ${COMMAND}
	fi
fi
if [ "${NEWGPBUILDER}" == "NO" ]; then
	echo "Pulling new data into GlycoProteinBuilder."
	COMMAND="( cd ${GW_PROGRAMS_DIR}/${GPBUILDER_DIR_NAME} && ${GPBUILDER_PULL_COMMAND} )"
	echo ${COMMAND}
	if [ "${TEST}" != "Y" ]; then
		eval ${COMMAND}
	fi
fi

# EXIT_SUCCESS
exit 0
