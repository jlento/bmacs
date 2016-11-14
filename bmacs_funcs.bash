#!/bin/bash

bmac-major-version () {
    set -- ${1//./ }
    echo "$1.$2"
}

bmac-head () {
    local head tail
    read head tail
    echo $head
}

bmac-setmod () {
    local conflicts="$(grep -xf <(awk '/^conflict/{print $2}' <(module show $* 2>&1)) <(module -t list 2>&1 | sed 's|/.*$||'))"
    echo "# ${FUNCNAME}"
    [ "$conflicts" ] && echo "module unload $conflicts"
    echo "module load $*"
    echo " "
}

bmac-print-vars () {
    local v
    local vs=(${!BMAC_*})
    local ds
    for v in ${vs[@]/BMAC_VAR_DESC}; do
	for ds in "$@"; do
	    [[ "$ds" =~ (.*):.*${v} ]] && break
	done
	printf "# %-20s %-18s = %s\n" "${BASH_REMATCH[1]}:" "$v" "${!v}"
    done
    echo
}

bmac-requires () {
    local var
    for var in "$@"; do
	: ${!var:?Set ${var}.}
    done
}

bmac-feeling-lucky () {
    compgen -c "$1" | { read head tail; echo $head; }
}

bmac-header () {
    echo "# ${FUNCNAME}"
    echo ' '
    module -t list 2>&1 | sed 's/.*/# &/'
    echo ' '
    bmac-print-vars "${BMAC_VAR_DESC[@]}"
    echo ' '
}

bmac-prep () {
    bmac-requires BMAC_BUILD_DIR BMAC_SRC BMAC_PKG
    echo "# ${FUNCNAME}"
    echo "cd ${BMAC_BUILD_DIR}"

    local modnames=$(FS=: compgen -W "${LOADEDMODULES}" -- "${BMAC_PKG_NAME}")
    [ "$modnames" ] && echo "module unload ${modnames}"

    local tgz=$(basename "${BMAC_SRC}")
    shopt -s nocasematch
    [[ "${tgz}" =~ (.*)(\.tar\.gz|\.tgz) ]]
    : ${srcdir:=${BASH_REMATCH[1]}}
    [ -e "${BMAC_BUILD_DIR}/${tgz}" ] || echo "${BMAC_SRC}"
    [ -e "${BMAC_BUILD_DIR}/${srcdir}" ] || echo "tar xvf ${tgz}"
    echo "cd ${srcdir}"
    echo ' '
}

bmac-configure () {
    echo "# ${FUNCNAME}"
    echo "export CC=${BMAC_CC:?Set BMAC_CC.}"
    echo "export FC=${BMAC_FC:?Set BMAC_FC.}"
    echo "export F77=${BMAC_F77:?Set BMAC_F77.}"
    echo "export CXX=${BMAC_CXX:?Set BMAC_CXX.}"
    local prefix="--prefix=${BMAC_INSTALL_DIR:?Set BMAC_INSTALL_DIR.}"
    if [ "$MACHTYPE" ]; then
	local mach=" --build=$MACHTYPE"
    else
	local mach=""
    fi
    echo "./configure ${prefix}${mach} $*"
    echo " "
}

bmac-permissions () {
    echo "# ${FUNCNAME}"
    echo "chmod -R a+rX,g+rwX ${BMAC_INSTALL_ROOT}/${BMAC_PKG_NAME}"
    echo "chmod -R a+rX,g+rwX ${BMAC_MODULEFILES}/${BMAC_PKG_NAME}"
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
	bash -ex $tmp 2>&1 | tee ${BMAC_INSTALL_DIR:?Set BMAC_INSTALL_DIR.}/build-$(date --rfc-3339=date).log
    else
	echo Exiting.
    fi
}
