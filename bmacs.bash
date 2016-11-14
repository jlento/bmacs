#!/bin/bash


# BMACS initialization stuff

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE[0]}))}
: ${BMAC_HOST_TAG:=${HOSTNAME%%[^[:alpha:]]*}}

source ${BMAC_ROOT}/bmacs_funcs.bash

read -d BMACS_USAGE <<EOF
Usage: bash ${BASH_SOURCE[0]} [-c|--c-compiler-only C-COMPILER] GET_SRC_CMD
EOF

BMAC_C_ONLY=false
BMACS_ARGS=$(getopt -n "${BASH_SOURCE[0]}" -o 'c:' -l c-compiler-only: -- "$@")
[ $? != 0 ] && { echo $BMACS_USAGE >&2 ; false; }
eval set -- "$BMACS_ARGS"
while true ; do
    case "$1" in
	-c|--c-compiler-only) BMAC_C_ONLY=true
			      : ${BMAC_CC:=$2}
			      : ${BMAC_CXX:=false}
			      : ${BMAC_FC:=false}
			      : ${BMAC_F77:=false}
			      shift 2 ;;
	--) shift ; break ;;
        *) echo "${BASH_SOURCE[0]}: Internal error with getopt!" 1>&2 ; break ;;
    esac
done
if [ $# -ne 1 ]; then
    echo $BMACS_USAGE >&2 ; false
else
    : ${BMAC_SRC:=$1}
fi


# Package defaults

: ${BMAC_PKG:=$(basename "${BMAC_SRC%.[t][ag][rz]*}")}
: ${BMAC_PKG_NAME:=${BMAC_PKG%-*}}
: ${BMAC_PKG_VERSION:=${BMAC_PKG##*-}}


# Environment defaults

source ${BMAC_ROOT}/configs/${BMAC_HOST_TAG}_bmacs_rc.bash

: ${BMAC_CS:=GNU}
: ${BMAC_CC:=gcc}
: ${BMAC_FC:=$(bmac-feeling-lucky gfortran)}
: ${BMAC_F77:=${BMAC_FC}}
: ${BMAC_CXX:=g++}
: ${BMAC_BUILD_DIR:=$TMPDIR}
: ${BMAC_INSTALL_ROOT:=$PWD}
: ${BMAC_INSTALL_DIR:=${BMAC_INSTALL_ROOT}}
: ${BMAC_MODULEFILES:=${BMAC_INSTALL_ROOT}/modulefiles}


# Decsription of the available variables

BMAC_VAR_DESC=(
    "Source download cmd: BMAC_SRC"
    "Source archive:      BMAC_TGZ"
    "Source dir name:     BMAC_PKG_SRC_DIR"
    "Package:             BMAC_PKG"
    "Package name:        BMAC_PKG_NAME"
    "Package version:     BMAC_PKG_VERSION"
    "Build host:          BMAC_HOST_TAG"
    "Build macros root:   BMAC_ROOT"
    "Compiler suite(CS):  BMAC_CS"
    "CS version:          BMAC_CS_VERSION"
    "C compiler:          BMAC_CC"
    "Fortran compiler:    BMAC_FC"
    "Fortran77 compiler:  BMAC_F77"
    "C++ compiler:        BMAC_CXX"
    "Build dir:           BMAC_BUILD_DIR"
    "Install root:        BMAC_INSTALL_ROOT"
    "Install dir:         BMAC_INSTALL_DIR"
    "Modulefiles dir:     BMAC_MODULEFILES"
    "Module dir:          BMAC_MODULE_DIR"
    "Module file:         BMAC_MODULE_FILE"
    "Only C API:          BMAC_C_ONLY")
