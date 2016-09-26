#!/bin/bash

: ${BMAC_CC:=cc}
: ${BMAC_FC:=ftn}
: ${BMAC_F77:=ftn}
: ${BMAC_CXX:=CC}
: ${BMAC_CS:=${PE_ENV:=GNU}}
: ${BMAC_INSTALL_ROOT:=/appl/climate}

case ${BMAC_CS} in
    INTEL)
	: ${BMAC_CS_VERSION:=$(bmac-major-version ${INTEL_VERSION})}
	;;
    GNU)
	: ${GNU_VERSION:=$(gcc --version | head | grep -Eo '\b[[:digit:]](\.[[:digit:]])*\b')}
	: ${BMAC_CS_VERSION:=$(bmac-major-version ${GNU_VERSION})}
	;;
    CRAY)
	: ${BMAC_CS_VERSION:=$(bmac-major-version ${CRAY_CC_VERSION})}
	;;
esac
: ${BMAC_INSTALL_DIR:=${BMAC_INSTALL_ROOT}/${BMAC_PKG_NAME:?Set BMAC_PKG_NAME.}/${BMAC_PKG_VERSION:?Set BMAC_PKG_VERSION.}/${BMAC_CS}/${BMAC_CS_VERSION}}


# Environment module stuff...

: ${BMAC_MODULEFILES:=${BMAC_INSTALL_ROOT}/modulefiles}
: ${BMAC_MODULE_DIR:=${BMAC_MODULEFILES:?Set BMAC_MODULEFILES}/${BMAC_PKG_NAME:?Set BMAC_PKG_NAME}}
: ${BMAC_MODULE_FILE:=${BMAC_MODULE_DIR}/${BMAC_PKG_VERSION:?Set BMAC_PKG_VERSION}}


bmac-modulefile () {
    echo "# ${FUNCNAME}"
    [ -d "${BMAC_MODULE_DIR}" ] || echo "mkdir -p ${BMAC_MODULE_DIR}"
    cat <<EOF
cat > ${BMAC_MODULE_FILE} <<EOF_MODULE_FILE
#%Module
#
# Module ${BMAC_PKG:?Set BMAC_PKG}
#
EOF_MODULE_FILE
EOF
}
