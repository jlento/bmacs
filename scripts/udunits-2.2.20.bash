#!/bin/bash

# udunits has C API, only (great!).

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE})/..)}

URL=ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.20.tar.gz

source "${BMAC_ROOT}/bmacs.bash" -c gcc "$URL"

bmac-yes-no <<EOF
$(bmac-header)
$(bmac-prep)
$(bmac-configure)
make clean
make -j 8 install

$(bmac-gen-pc)
$(bmac-modulefile)
EOF
