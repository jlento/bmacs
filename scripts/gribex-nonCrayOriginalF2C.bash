#!/bin/bash

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE})/..)}

URL=https://svn.ec-earth.org/ecearth3/vendor/gribex/gribex_ece/nonCrayOriginalF2C
BMAC_PKG=gribex-nonCrayOriginalF2C

source "${BMAC_ROOT}/bmacs.bash" "svn checkout --non-interactive --trust-server-cert $URL"

bmac-yes-no <<EOF
$(bmac-header)
$(bmac-prep)
$(bmac-setmod craype-sandybridge udunits)

export LDFLAGS="-Wl,--as-needed"
./build_library noncray <<EOF_ANSWERS
$(case ${BMAC_CS} in (GNU) echo y ;; (INTEL) echo i ;; esac)
y
${BMAC_INSTALL_DIR}/lib
n
EOF_ANSWERS
./install

$(bmac-gen-pc gribexR64:udunits2)
$(bmac-modulefile)
$(bmac-permissions)
EOF
