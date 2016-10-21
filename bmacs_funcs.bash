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
    bmac-print-vars "${BMAC_VAR_DESC[@]}"
}

bmac-prep () {
    bmac-requires BMAC_BUILD_DIR BMAC_SRC BMAC_PKG
    echo "# ${FUNCNAME}"
    echo "cd ${BMAC_BUILD_DIR}"

    local modnames=$(FS=: compgen -W "${LOADEDMODULES}" -- "${BMAC_PKG_NAME}")
    [ "$modnames" ] && echo "module unload ${modnames}"

    local tgz=$(basename "${BMAC_SRC##* }")
    [ -e "${tgz}" ] || echo "${BMAC_SRC}"
    case "${tgz}" in
	*.tar.gz)
	    echo "tar xvf ${tgz}"
	    tgz=${tgz%.tar.gz}
	    ;;
	*.tgz)
	    tar xvf ${tgz}
	    echo "tgz=${tgz%.tgz}"
	    ;;
    esac
    echo "cd ${tgz}"
    echo ' '
}

bmac-configure () {
    echo "# ${FUNCNAME}"
    echo "export CC=${BMAC_CC:?Set BMAC_CC.}"
    echo "export FC=${BMAC_FC:?Set BMAC_FC.}"
    echo "export F77=${BMAC_F77:?Set BMAC_F77.}"
    echo "export CXX=${BMAC_CXX:?Set BMAC_CXX.}"
    echo "./configure --prefix=${BMAC_INSTALL_DIR:?Set BMAC_INSTALL_DIR.} $*"
    echo " "
}

bmac-permissions () {
    chmod -R a+rX ${BMAC_INSTALL_ROOT}/${BMAC_PKG_NAME}
    chmod -R a+rX ${BMAC_MODULEFILES}/${BMAC_PKG_NAME}
}

bmac-yes-no () {
    local tmp=$(mktemp)
    trap "rm -f $tmp" SIGINT SIGTERM EXIT
    tee $tmp
    exec 0</dev/tty
    read -r -p "Continue? [y/N] " response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
    then
	bash -ex $tmp
    else
	echo Exiting.
    fi
}
