#!/bin/bash
###########################################
debug=$1

gpu=cuda
adios=""

###########################################

if [ "$1" == "" ]; then echo "usage: ./configure.sh debug[0==off/1==on]"; exit 1; fi


#see: ~/.bashrc
source /etc/profile
module list

mpif90=mpif90
f90=xlf90
cc=xlc

## cray compilers
#flags="-eF -em -rm"
#cflags="-h list=m"

## gnu compilers
#warn="-Wunused -Waliasing -Wampersand -Wcharacter-truncation -Wline-truncation -Wsurprising -Wno-tabs -Wunderflow"
warn="-Wall -Wno-conversion -Wno-maybe-uninitialized"

if [ "$debug" == "1"  ]; then
  #debug

  ## cray
  #flags="-g -Rb -eF -rm -eC -eD" # -hfp2"
  #cflags="-g -h list=m"

  ## gnu
  #flags="-O2 -g -ggdb -fbacktrace -fbounds-check -frange-check -fcheck=all -mcmodel=medium $warn" # not avail: -fsanitize=leak
  #cflags="-O2 -g -ggdb -fbounds-check -Wall"

  ## xlf
  flags=""
  cflags=""

  vec="--disable-vectorization"
else
  #run

  ## cray
  #flags="-eF -em -rm -O3,fp3"
  #flags="-eF -em -rm"
  #cflags="-h list=m"
  ## memory > 2GB
  #flags="-eF -em -rm -O3,fp3 -hpic -dynamic"
  #cflags="-h list=m -hpic -dynamic"

  ## gnu
  #flags="-O3 -mcmodel=medium $warn"
  #cflags=""

  ## xlf
  flags="-qtune=auto -qarch=auto -qhalt=w -qlanglvl=2008std -qsuppress=1518-318 -qsuppress=1518-234 -O4 -qstrict"
  cflags=""

  vec="--enable-vectorization"
fi

# configuration fails without indicating that we are cross-compiling,
# so we add --host option:
#host="--host=x86_64"  #--host=x86_64-unknown-linux-gnu # CRAY_CPU_TARGET=x86-64

## MPI
MPI_INC="${OMPI_DIR}/include"

## CUDA
CUDA_INC="${CUDA_DIR}/include"
CUDA_LIB="${CUDA_DIR}/lib64"
CUDA_FLAGS=(-Xcompiler -Wall,-Wno-unused-function,-Wno-unused-const-variable --ptxas-options -v)

## ADIOS
#ADIOS_CONFIG="/opt/adios/bin/adios_config"
ADIOS_INC="${ADIOS_INC}"
ADIOS_LIB="${ADIOS_FLIB}"
#ADIOS_CONFIG="/home/peterdb/install/adios/bin/adios_config"
if [ "$adios" == "adios" ]; then
  echo
  echo "using adios:"
  #adios=(--with-adios ADIOS_CONFIG=$ADIOS_CONFIG)
  adios=(--with-adios ADIOS_INC="$ADIOS_INC" ADIOS_LIB="$ADIOS_LIB")
  echo "  ${adios[*]}"
  echo
else
  adios=()
fi

# configuration
if [ "$gpu" == "cuda" ]; then

echo "configuration for cuda version..." 
echo
./configure $vec $host \
--with-cuda=cuda9 CUDA_FLAGS="${CUDA_FLAGS[*]}" CUDA_LIB="$CUDA_LIB" CUDA_INC="$CUDA_INC" \
${adios[*]} \
MPIF90=$mpif90 F90=$f90 CC=$cc FLAGS_CHECK="${flags}" CFLAGS="${cflags}" MPI_INC="$MPI_INC"

else

echo "configuration for non-cuda version..."
echo
./configure $vec $host \
${adios[*]} \
MPIF90=$mpif90 F90=$f90 CC=$cc FLAGS_CHECK="${flags}" CFLAGS="${cflags}" MPI_INC="$MPI_INC"

fi

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

