#!/bin/bash

URL=https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.17.0-Source.tar.gz
BMAC_PKG=grib_api-1.17.0

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE})/..)}
source "${BMAC_ROOT}/bmacs.bash" "$URL"

bmac-yes-no <<EOF
$(bmac-prep)
$(bmac-setmod craype-sandybridge cray-hdf5-parallel cray-netcdf-hdf5parallel)
$(bmac-configure --with-netcdf=\$NETCDF_DIR --disable-jpeg --disable-shared)
make -j 8 install

$(bmac-gen-pc)
$(bmac-modulefile)
EOF
