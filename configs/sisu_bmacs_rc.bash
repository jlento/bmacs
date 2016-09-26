#!/bin/bash

: ${BMAC_CC:=cc}
: ${BMAC_FC:=ftn}
: ${BMAC_F77:=ftn}
: ${BMAC_CXX:=CC}
: ${BMAC_CS:=${PE_ENV}}

: ${BMAC_INSTALL_ROOT:=/appl/climate}
case ${PE_ENV} in
    INTEL)
	: ${BMAC_CS_VERSION:=$(bmac-major-version ${INTEL_VERSION})}
	;;
    GNU)
	: ${BMAC_CS_VERSION:=$(bmac-major-version ${GNU_VERSION})}
	;;
    CRAY)
	: ${BMAC_CS_VERSION:=$(bmac-major-version ${CRAY_CC_VERSION})}
	;;
esac
: ${BMAC_INSTALL_DIR:=${BMAC_INSTALL_ROOT}/${BMAC_PKG:?Set BMAC_PKG.}/${BMAC_CS}/${BMAC_CS_VERSION}}

bmac-modulefile () {
    cat <<EOF
cat > ${BMAC_MODULEFILES} <<EOF_MODULE_FILE

EOF_MODULE_FILE
EOF
}
