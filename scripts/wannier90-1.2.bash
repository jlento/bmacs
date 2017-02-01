#!/bin/bash

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE})/..)}

BMAC_INSTALL_ROOT=/appl/nano
BMAC_MODULEFILES=/appl/modulefiles

URL=http://www.wannier.org/code/wannier90-1.2.tar.gz

source "${BMAC_ROOT}/bmacs.bash" "wget $URL"

bmac-yes-no <<EOF
$(bmac-header)
$(bmac-prep)
make wannier lib F90=ftn \
    FCOPTS="$($MKLROOT/tools/mkl_link_tool -opts | tr '()' '{}')" \
    LIBS="$($MKLROOT/tools/mkl_link_tool -l static -libs | tr '()' '{}')" \
    LIBDIR= LDOPTS=
mkdir -p ${BMAC_INSTALL_DIR}/{bin,lib}
install wannier90.x ${BMAC_INSTALL_DIR}/bin
install libwannier.a ${BMAC_INSTALL_DIR}/lib
$(bmac-gen-pc)
$(bmac-modulefile -o /appl)
$(bmac-permissions)
EOF
