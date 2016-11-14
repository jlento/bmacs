#!/bin/bash

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE})/..)}

URL=https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.17.0-Source.tar.gz
BMAC_PKG=grib_api-1.17.0

source "${BMAC_ROOT}/bmacs.bash" "wget $URL"

module use /appl/climate/modulefiles
module unload grib_api
module unload craype-haswell
module load craype-sandybridge
module load cray-hdf5-parallel cray-netcdf-hdf5parallel
case "$BMAC_CS" in
    GNU)
	BMAC_CC=gcc
	BMAC_CXX=g++
	BMAC_FC=gfortran
	BMAC_F77=gfortran
	CCFLAGS="-g -O2"
	FCFLAGS="-g -O2"
	;;
    INTEL)
	BMAC_CC=icc
	BMAC_FC=ifort
	BMAC_CXX=icpc
	BMAC_F77=ifort
	CFLAGS="-g -O1 -fp-model precise"
	FCFLAGS="-g -O1 -fp-model precise"
	;;
    CRAY)
	BMAC_CC=cc
	BMAC_FC=ftn
	BMAC_CXX=CC
	BMAC_F77=ftn
	CFLAGS="-O1 -G2 -hflex_mp=conservative -hadd_paren -hfp1"
	FCFLAGS="-O1 -G2 -hflex_mp=conservative -hadd_paren -hfp1"
	;;
    *)
	print "Could not guess compiler suite" >&2
	false
esac

bmac-yes-no <<EOF
$(bmac-header)
$(bmac-prep)
export CFLAGS="$CFLAGS" FCFLAGS="$FCFLAGS"
$(bmac-configure --with-netcdf=$NETCDF_DIR --enable-pthread --disable-jpeg --disable-shared)
make clean
make -j 8 install

$(bmac-gen-pc)
$(bmac-modulefile)
$(bmac-permissions)
EOF
