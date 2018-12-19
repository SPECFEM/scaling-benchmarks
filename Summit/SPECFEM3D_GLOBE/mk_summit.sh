#!/bin/bash

# binaries: 1 == forward, 2 == adjoint/kernel
forward=$1

##################################################################

if [ "$forward" == "" ]; then echo "usage: ./mk_summitdev.sh forward(==1/==2 for kernel binaries)"; exit 1; fi

#see: ~/.bashrc
source /etc/profile
module list

## compilation for xcreate_header_file
## to run on login node
echo
echo "compiling xcreate_header_file..."
echo

# changes target rules
if [ -e src/create_header_file/rules.mk ]; then
  # new makefile - rules
  sed -i 's:@-rm -f $@.*:@-rm -f $@; cp bin.header_file/xcreate_header_file $E/:' src/create_header_file/rules.mk
else
  # old makefile
  sed -i "s:(cd ../create_header_file; make):#(cd ../create_header_file; make):g" src/specfem3D/Makefile
  sed -i "s:(cd ../create_header_file; make):#(cd ../create_header_file; make):g" src/auxiliaries/Makefile
fi

mkdir -p bin

##
## compiles xcreate_header_file
## (for static compilation)

#module switch $default $host
echo
module list
echo

make clean
make -j 4 xcreate_header_file
if [ ! -e bin/xcreate_header_file ]; then exit; fi

rm -rf bin.header_file
cp -rp bin bin.header_file

# test
./bin/xcreate_header_file
if [[ $? -ne 0 ]]; then exit 1; fi

#module switch $host $default
echo
module list
echo

if [ "$forward" == "1" ]; then

# forward simulations
#
# only needed to produce synthetics for flexwin/measurements
#
echo
echo "compiling forward simulations..."
echo
make clean

rm -rf OUTPUT_FILES/*
rm -rf bin.forward

./change_simulation_type.pl -f

mkdir -p bin
cp bin.header_file/* bin/
make -j 8 xmeshfem3D
if [ ! -e bin/xmeshfem3D ]; then echo "compilation failed, please check..."; exit 1; fi

make -j 8 xspecfem3D
if [ ! -e bin/xspecfem3D ]; then echo "compilation failed, please check..."; exit 1; fi

make -j 8 all

cp -rp bin bin.forward
mv OUTPUT_FILES/* bin.forward/

if [ ! -e bin.forward/xspecfem3D ]; then exit 1; fi

fi


if [ "$forward" == "2" ]; then

# kernel simulations
#
# needed for forward/backward simulations to create adjoint kernels
#
echo
echo "compiling kernel simulations..."
echo
make clean
rm -rf OUTPUT_FILES/*

rm -rf bin.kernel
./change_simulation_type.pl -b

mkdir -p bin
cp bin.header_file/* bin/

make -j 8 xmeshfem3D
if [ ! -e bin/xmeshfem3D ]; then echo "compilation failed, please check..."; exit 1; fi

make -j 8 xspecfem3D
if [ ! -e bin/xspecfem3D ]; then echo "compilation failed, please check..."; exit 1; fi

make -j 8 all

cp -rf bin bin.kernel
mv OUTPUT_FILES/* bin.kernel/

if [ ! -e bin.kernel/xspecfem3D ]; then exit 1; fi

fi

echo
echo

#make clean
./change_simulation_type.pl -f

echo
echo "done successfully"
echo

