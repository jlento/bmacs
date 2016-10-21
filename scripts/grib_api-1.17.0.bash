#!/bin/bash

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE})/..)}

URL=https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.17.0-Source.tar.gz

source "${BMAC_ROOT}/bmacs.bash" "wget $URL"

bmac-yes-no <<EOF
$(bmac-prep)
$(bmac-setmod craype-sandybridge cray-hdf5-parallel cray-netcdf-hdf5parallel)
$(bmac-configure --with-netcdf=\$NETCDF_DIR --disable-jpeg --disable-shared)
make -j 8 install

$(bmac-gen-pc)
$(bmac-modulefile)
$(bmac-permissions)
EOF
