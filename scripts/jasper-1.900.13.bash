#!/bin/bash

# jasper has C API, only (great!).

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE})/..)}

URL=http://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.13.tar.gz

source "${BMAC_ROOT}/bmacs.bash" -c gcc "wget $URL"

bmac-yes-no <<EOF
$(bmac-header)
$(bmac-prep)
$(bmac-configure)
make clean
make -j 8 install

$(bmac-gen-pc)
$(bmac-modulefile)
$(bmac-permissions)
EOF
