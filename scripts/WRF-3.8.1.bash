#!/bin/bash

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE})/..)}

URL=http://www2.mmm.ucar.edu/wrf/src/WRFV3.8.1.TAR.gz
BMAC_PKG=WRF-3.8.1

source "${BMAC_ROOT}/bmacs.bash" "wget $URL"

module use /appl/climate/modulefiles
module load cray-hdf5-parallel cray-netcdf-hdf5parallel
case "${PE_ENV}" in INTEL) arch=50;; CRAY) arch=46;; *) false;; esac

bmac-yes-no <<EOF
$(bmac-header)
$(srcdir=WRFV3 bmac-prep)

export NETCDF=$NETCDF_DIR PHDF5=$HDF5_DIR WRFIO_NCD_LARGE_FILE_SUPPORT=1
./clean -a
./configure <<<'${arch}

'
export WRF_EM_CORE=1
./compile -j 8 em_b_wave

$(bmac-gen-pc)
$(bmac-modulefile)
$(bmac-permissions)
EOF
