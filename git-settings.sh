#!/usr/bin/env bash

GEMS_DIR_NAME="gems"
GEMS_BRANCH="gems-dev"
GEMS_URL="https://github.com/GLYCAM-Web/gems.git"
GEMS_CLONE_COMMAND="git clone -b ${GEMS_BRANCH} --single-branch ${GEMS_URL}"
GEMS_PULL_COMMAND="git pull origin ${GEMS_BRANCH}"
GEMS_PUSH_COMMAND="git push origin ${GEMS_BRANCH}"

GMML_DIR_NAME="gmml"
GMML_BRANCH="gmml-dev"
GMML_URL="https://github.com/GLYCAM-Web/gmml.git"
GMML_CLONE_COMMAND="git clone -b ${GMML_BRANCH} --single-branch ${GMML_URL}"
GMML_PULL_COMMAND="git pull origin ${GMML_BRANCH}"
GMML_PUSH_COMMAND="git push origin ${GMML_BRANCH}"

if [ -f ./LocalGitSettings.sh ]; then
	source ./LocalGitSettings.sh
fi
