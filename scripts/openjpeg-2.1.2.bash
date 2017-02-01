#!/bin/bash

# OpenJPEG has C API, only (great!).

: ${BMAC_ROOT:=$(readlink -f $(dirname ${BASH_SOURCE})/..)}

URL=https://github.com/uclouvain/openjpeg/archive/v2.1.2.tar.gz
BMAC_PKG=openjpeg-2.1.2
source "${BMAC_ROOT}/bmacs.bash" -c gcc "wget $URL -O ./${BMAC_PKG}.tar.gz"

eval "$(bmac-setmod craype-sandybridge cmake)"

bmac-yes-no <<EOF
$(bmac-header)
$(bmac-prep)

mkdir -p build ${BMAC_INSTALL_DIR}/lib/${BMAC_PKG}
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$BMAC_INSTALL_DIR -DCMAKE_C_COMPILER=gcc -DBUILD_THIRDPARTY=ON
make clean
make -j 8
make install
cmake .. -DCMAKE_INSTALL_PREFIX=$BMAC_INSTALL_DIR -DCMAKE_C_COMPILER=gcc -DBUILD_THIRDPARTY=ON -DBUILD_SHARED_LIBS=OFF
make clean
make -j 8
make install

$(bmac-gen-pc)
$(bmac-modulefile)
$(bmac-permissions)
EOF
