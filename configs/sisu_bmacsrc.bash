#!/bin/bash

: ${BMAC_INSTALL_ROOT:=/appl/climate}
: ${BMAC_CS:=${PE_ENV}}
: ${BMAC_CS_VERSION:=$(eval echo \$${PE_ENV}_MAJOR_VERSION)}
: ${BMAC_CC:=cc}
: ${BMAC_FC:=ftn}
: ${BMAC_F77:=ftn}
: ${BMAC_CXX:=CC}

