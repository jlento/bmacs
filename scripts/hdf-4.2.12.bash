#!/bin/bash

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE})/..)}

URL=https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.12/src/hdf-4.2.12.tar.gz

source "${BMAC_ROOT}/bmacs.bash" "wget $URL"

bmac-yes-no <<EOF
$(bmac-prep)
$(bmac-setmod craype-sandybridge)
$(bmac-configure --disable-netcdf --host=x86_64-unknown-linux \
  FLIBS=  ac_cv_f77_compiler_gnu=no ac_cv_f77_libs= )
make -j 8 install

$(bmac-gen-pc)
$(bmac-modulefile)
$(bmac-permissions)
EOF
