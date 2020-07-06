#!/usr/bin/env bash

source "./functions.sh"

var="hello"
var=""

if variable_is_empty ${var}  ; then
	echo "the var variable is empty"
else
	echo "the var variable is NOT empty"
fi
if variable_is_empty ${1} ; then
	echo "the #1 variable is empty"
else
	echo "the #1 variable is NOT empty"
fi

check_make_directory ${1}
