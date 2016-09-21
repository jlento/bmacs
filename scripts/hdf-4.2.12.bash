#!/bin/bash

PKG_NAME=hdf
PKG_VERSION=4.2.12
PKG=${PKG_NAME}-${PKG_VERSION}

URL=https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.12/src/${PKG}.tar.gz


source ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE})/..)}/bmacs.bash $URL

bmac-yes-no <<EOF
$(bmac-prep)
$(bmac-setmod craype-sandybridge)
$(bmac-configure --disable-netcdf --host=x86_64-unknown-linux --disable-shared \
  FLIBS=  ac_cv_f77_compiler_gnu=no)
make -j 8 install
EOF
