#!/bin/bash

debug=$1


###########################################

if [ "$1" == "" ]; then echo "usage: ./configure.sh debug[0==off/1==on]"; exit 1; fi


#see: ~/.bashrc
source /etc/profile
module list

mpif90=ftn
f90=ftn
cc=cc

## cray compilers
#flags="-eF -em -rm"
#cflags="-h list=m"

## gnu compilers
#warn="-Wunused -Waliasing -Wampersand -Wcharacter-truncation -Wline-truncation -Wsurprising -Wno-tabs -Wunderflow"
warn="-Wall -Wno-conversion -Wno-maybe-uninitialized"

if [ "$debug" == "1"  ]; then
  #debug

  ## cray
  flags="-g -Rb -eF -rm -eC -eD" # -hfp2"
  cflags="-g -h list=m"

  ## gnu
  #flags="-O2 -g -ggdb -fbacktrace -fbounds-check -frange-check -fcheck=all -mcmodel=medium $warn" # not avail: -fsanitize=leak
  #cflags="-O2 -g -ggdb -fbounds-check -Wall"

  vec="--disable-vectorization"
else
  #run

  ## cray
  #flags="-eF -em -rm -O3,fp3"
  #flags="-eF -em -rm"
  #cflags="-h list=m"
  ## memory > 2GB
  flags="-eF -em -rm -O3,fp3 -hpic -dynamic"
  cflags="-h list=m -hpic -dynamic"

  ## gnu
  #flags="-O3 -mcmodel=medium $warn"
  #cflags=""

  vec="--enable-vectorization"
fi

# configuration fails without indicating that we are cross-compiling,
# so we add --host option:
host="--host=x86_64"  #--host=x86_64-unknown-linux-gnu # CRAY_CPU_TARGET=x86-64

## MPI
MPI_INC="${CRAY_MPICH2_DIR}/include"

## CUDA
CUDA_INC="${CRAY_CUDATOOLKIT_DIR}/include"
CUDA_LIB="${CRAY_CUDATOOLKIT_DIR}/lib64"

## ADIOS
#ADIOS_CONFIG="/opt/adios/bin/adios_config"
ADIOS_INC="${ADIOS_INC}"
ADIOS_LIB="${ADIOS_FLIB}"


# w/out adios
./configure $vec $host \
--with-cuda=cuda5 CUDA_INC="$CUDA_INC" CUDA_LIB="$CUDA_LIB" MPI_INC="$MPI_INC" \
MPIF90=$mpif90 F90=$f90 CC=$cc FLAGS_CHECK="$flags" CFLAGS="$cflags"


# w/ adios
#./configure $vec $host \
#--with-cuda=cuda5 CUDA_INC="$CUDA_INC" CUDA_LIB="$CUDA_LIB" MPI_INC="$MPI_INC" \
#--with-adios ADIOS_INC="$ADIOS_INC" ADIOS_LIB="$ADIOS_LIB" \
#MPIF90=$mpif90 F90=$f90 CC=$cc FLAGS_CHECK="$flags" CFLAGS="$cflags"

##
## setup
##
#echo
#echo "modifiying constants.h..."

# file to change
#file=./setup/constants.h

## ETOPO1
#echo "ETOPO1..."
#sed -i "s:NX_BATHY.*:NX_BATHY = 21600,NY_BATHY = 10800:g" $file
#sed -i "s:RESOLUTION_TOPO_FILE.*:RESOLUTION_TOPO_FILE = 1:g" $file
#sed -i "s:PATHNAME_TOPO_FILE.*:PATHNAME_TOPO_FILE = 'DATA/topo_bathy/ETOPO1.xyz':g" $file
#sed -i "s:SMOOTH_CRUST.*:SMOOTH_CRUST = .false.:g" $file

#echo
#echo "modifying mesh_constants_cuda.h..."
#sed -i "/ENABLE_VERY_SLOW_ERROR_CHECKING/ c\#undef ENABLE_VERY_SLOW_ERROR_CHECKING" src/cuda/mesh_constants_cuda.h

echo
echo "done"
echo

