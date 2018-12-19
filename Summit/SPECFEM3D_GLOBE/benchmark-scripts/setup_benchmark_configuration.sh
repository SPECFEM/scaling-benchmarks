#!/bin/sh
#
# modifies setup for SPECFEM3D_GLOBE benchmarks
#
# usage:
#       ./setup_directory.no-configuration.sh
######################################################

# root directory
sourcedir=~/SPECFEM3D_GLOBE/

######################################################

#if [ "$sourcedir" == "" ]; then
#  echo "usage: ./setup_directory.sh  ~/SPECFEM3D_GLOBE/"
#  exit
#fi

currentdir=`pwd`

echo "configuration & compilation setup: `date`"
echo "  source in directory: $sourcedir"
echo "  working directory: $currentdir"
echo
sleep 1

# configuration

cd $sourcedir

# file to change
file=./setup/constants.h

echo
echo "modifying $file"
# mesh coloring
sed -i "s:USE_MESH_COLORING_GPU.*:USE_MESH_COLORING_GPU = .false.:g" $file
# benchmark run
sed -i "s:DO_BENCHMARK_RUN_ONLY.*:DO_BENCHMARK_RUN_ONLY = .true.:g" $file

if [[ $? -ne 0 ]]; then echo "configuration failed"; exit 1; fi

echo
echo "done configuration"
echo



