#!/bin/bash

# BMACS initialization stuff

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE}))}
: ${BMAC_HOST_TAG:=${HOSTNAME%%[^[:alpha:]]*}}

source ${BMAC_ROOT}/bmacs_funcs.bash


# Package defaults
# Derived from the 1st argument to this script, the download URL of the package.

: ${BMAC_URL:=$1}
: ${BMAC_TGZ:=$(basename ${BMAC_URL})}
: ${BMAC_PKG:=${BMAC_TGZ%.[t][ag][rz]*}}
: ${BMAC_PKG_NAME:=${BMAC_PKG%-*}}
: ${BMAC_PKG_VERSION:=${BMAC_PKG##*-}}


# Environment defaults

source ${BMAC_ROOT}/configs/${BMAC_HOST_TAG}_bmacs_rc.bash

: ${BMAC_CS:=GNU}
: ${BMAC_CC:=gcc}
: ${BMAC_FC:=gfortran}
: ${BMAC_F77:=gfortran}
: ${BMAC_CXX:=g++}
: ${BMAC_BUILD_DIR:=$TMPDIR}
: ${BMAC_INSTALL_ROOT:=$PWD}
: ${BMAC_INSTALL_DIR:=${BMAC_INSTALL_ROOT}/${BMAC_PKG}}
: ${BMAC_MODULEFILES:=${BMAC_INSTALL_ROOT}/modulefiles}


# Decsription of the available variables

BMAC_VAR_DESC=(
    "Download URL:       BMAC_URL"
    "Source archive:     BMAC_TGZ"
    "Package:            BMAC_PKG"
    "Package name:       BMAC_PKG_NAME"
    "Package version:    BMAC_PKG_VERSION"
    "Build host:         BMAC_HOST_TAG"
    "Build macros root:  BMAC_ROOT"
    "Compiler suite(CS): BMAC_CS"
    "CS version:         BMAC_CS_VERSION"
    "C compiler:         BMAC_CC"
    "Fortran compiler:   BMAC_FC"
    "Fortran77 compiler: BMAC_F77"
    "C++ compiler:       BMAC_CXX"
    "Build dir:          BMAC_BUILD_DIR"
    "Install root:       BMAC_INSTALL_ROOT"
    "Install dir:        BMAC_INSTALL_DIR"
    "Modulefiles dir:    BMAC_MODULEFILES")

bmac-print-vars "${BMAC_VAR_DESC[@]}"
