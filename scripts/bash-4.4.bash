#!/bin/bash

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE})/..)}

URL=https://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz

source "${BMAC_ROOT}/bmacs.bash" -c gcc "wget $URL"

bmac-yes-no <<EOF
$(bmac-header)
$(bmac-prep)
$(bmac-configure --without-bash-malloc)

make -j 8 install

$(bmac-modulefile)
$(bmac-permissions)
EOF
