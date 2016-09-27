#!/bin/bash

bmac-major-version () {
    set -- ${1//./ }
    echo "$1.$2"
}

bmac-setmod () {
    local conflicts=$(grep -o -f <(awk '/^conflict/{print $2}' <(module show $* 2>&1)) <(module list 2>&1))
    echo "# ${FUNCNAME}"
    echo "module unload $conflicts"
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

bmac-prep () {
    echo "# ${FUNCNAME}"
    echo "cd ${BMAC_BUILD_DIR:?Set BMAC_BUILD_DIR}"
    if [ ! -d "${BMAC_BUILD_DIR}/${BMAC_PKG:?Set BMAC_PKG}" ]; then
	if [ ! -f "${BMAC_BUILD_DIR}/${BMAC_TGZ:?Set BMAC_TGZ}" ]; then
	    echo "wget ${BMAC_URL:?Set BMAC_URL}"
	fi
	echo "tar xvf ${BMAC_TGZ}"
    fi
    echo "cd ${BMAC_PKG}"
    echo " "
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
