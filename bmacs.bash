#!/bin/bash

: ${BMAC_HOST:=${HOSTNAME%%[^[:alpha:]]*}}
source ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE}))}/configs/${BMAC_HOST}_bmacsrc.bash

echo "Build host:         BMAC_HOST         = ${BMAC_HOST}"
echo "Build macros root:  BMAC_ROOT         = ${BMAC_ROOT}"
echo "Download URL:       BMAC_URL          = ${BMAC_URL:=$1}"
echo "Source archive:     BMAC_TGZ          = ${BMAC_TGZ:=$(basename ${BMAC_URL})}"
echo "Package name:       BMAC_PKG          = ${BMAC_PKG:=${BMAC_TGZ%.[t][ag][rz]*}}"
echo "Compiler suite:     BMAC_CS           = ${BMAC_CS:=GNU}"
echo "C compiler:         BMAC_CC           = ${BMAC_CC:=gcc}"
echo "Fortran compiler:   BMAC_FC           = ${BMAC_FC:=gfortran}"
echo "Fortran77 compiler: BMAC_F77          = ${BMAC_F77:=gfortran}"
echo "C++ compiler:       BMAC_CXX          = ${BMAC_CXX:=g++}"
echo "Build dir:          BMAC_BUILD_DIR    = ${BMAC_BUILD_DIR:=$TMPDIR}"
echo "Install root:       BMAC_INSTALL_ROOT = ${BMAC_INSTALL_ROOT:=$PWD}"
echo "Install dir:        BMAC_INSTALL_DIR  = ${BMAC_INSTALL_DIR:=${BMAC_INSTALL_ROOT}/${BMAC_PKG}/${BMAC_CS}/${BMAC_CS_VERSION}}"
echo

bmac-setmod () {
    local conflicts=$(grep -o -f <(awk '/^conflict/{print $2}' <(module show $* 2>&1)) <(module list 2>&1))

    echo "# ${FUNCNAME}"
    echo "module unload $conflicts"
    echo "module load $*"
    echo " "
}

bmac-prep () {
    echo "# ${FUNCNAME}"
    if [ ! -d "${BMAC_BUILD_DIR}/${BMAC_PKG:?Set BMAC_PKG}" ]; then
	if [ ! -f "${BMAC_TGZ:?Set BMAC_TGZ}" ]; then
	    echo "wget ${BMAC_URL:?Set BMAC_URL}"
	fi
	echo "( cd ${BMAC_BUILD_DIR}; tar xvf ${BMAC_TGZ} )"
    fi
    echo "cd ${BMAC_BUILD_DIR}/${BMAC_PKG:?Set BMAC_PKG}"
    echo " "
}

bmac-configure () {
    echo "# ${FUNCNAME}"
    echo "./configure --prefix=${BMAC_INSTALL_DIR:?Set BMAC_INSTALL_DIR.} $*" \
	 "CC=${BMAC_CC:?Set BMAC_CC.}" \
	 "FC=${BMAC_FC:?Set BMAC_FC.}" \
	 "F77=${BMAC_F77:?Set BMAC_F77.}" \
	 "CXX=${BMAC_CXX:?Set BMAC_CXX.}"
    echo " "
}

bmac-yes-no () {
    local tmp=$(mktemp)
    trap "rm -f $tmp" SIGINT SIGTERM EXIT
    tee $tmp
    exec 0</dev/tty
    read -r -p "Continue? [y/N] " response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
    then
	bash $tmp
    else
	echo Exiting.
    fi
}
