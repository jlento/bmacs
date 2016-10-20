#!/bin/bash

: ${BMAC_INSTALL_ROOT:=/appl/climate}
: ${BMAC_CS:=${PE_ENV}}

if [ "${BMAC_CS}" ]; then
    : ${BMAC_CC:=cc}
    : ${BMAC_FC:=ftn}
    : ${BMAC_F77:=ftn}
    : ${BMAC_CXX:=CC}
fi

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

if $BMAC_C_ONLY; then
    : ${BMAC_INSTALL_DIR:=${BMAC_INSTALL_ROOT}/${BMAC_PKG_NAME:?Set BMAC_PKG_NAME.}/${BMAC_PKG_VERSION:?Set BMAC_PKG_VERSION.}}
else
    : ${BMAC_INSTALL_DIR:=${BMAC_INSTALL_ROOT}/${BMAC_PKG_NAME:?Set BMAC_PKG_NAME.}/${BMAC_PKG_VERSION:?Set BMAC_PKG_VERSION.}/${BMAC_CS}/${BMAC_CS_VERSION}}
fi

bmac-gen-pc () {
    echo "# ${FUNCNAME}"
    echo "module load craypkg-gen"
    echo "craypkg-gen -p ${BMAC_INSTALL_DIR:?Set BMAC_INSTALL_DIR.}"
    # This allows inserting dependencies to external static libraries as positional arguments of the form
    # "dependee:dependency1:dependency2", etc.
    echo "for dep in $@; do"
    echo "    find ${BMAC_INSTALL_DIR}"' -name ${dep%%:*}.pc | {'
    echo '        while read fname; do'
    echo '            sed -i "s/#external-requires#/${dep#*:}/" $fname'
    echo '        done'
    echo '    }'
    echo 'done'
    echo " "
}


# Environment module stuff...

: ${BMAC_MODULEFILES:=${BMAC_INSTALL_ROOT}/modulefiles}

bmac-modulefile () {
    echo "# ${FUNCNAME}"
    $(bmac-requires BMAC_MODULEFILES BMAC_INSTALL_ROOT BMAC_PKG_NAME BMAC_PKG_VERSION)
    [ -d "${BMAC_MODULEFILES}" ] || echo "mkdir -p ${BMAC_MODULEFILES}"
    echo "module load craypkg-gen"
    echo "craypkg-gen -m ${BMAC_INSTALL_ROOT}/${BMAC_PKG_NAME}/${BMAC_PKG_VERSION}"
    echo " "
}
