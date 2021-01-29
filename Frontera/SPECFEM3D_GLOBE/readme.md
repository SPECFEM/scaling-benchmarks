# Scaling Test Setup

Date: Nov. 23, 2020


#### Code setup

Modules loaded:
```
  1) git/2.24.1      3) cmake/3.16.1   5) hwloc/1.11.12   7) TACC           9) impi/19.0.7    11) phdf5/1.10.4
  2) autotools/1.2   4) pmix/3.1.4     6) xalt/2.9.7      8) intel/19.1.1  10) python3/3.7.0  12) cuda/10.1    (g)
```


Makefile compilation flags:
```
FC = ifort
FCFLAGS = 
FC_DEFINE = -D
MPIFC = mpiifort
MPILIBS = 

FLAGS_CHECK = -O3 -assume byterecl -warn all,noexternal -DFORCE_VECTORIZATION

FCFLAGS_f90 = -module ./obj -I./obj -I.  -I. -I${SETUP}

FC_MODEXT = mod
FC_MODDIR = ./obj

FCCOMPILE_CHECK = ${FC} ${FCFLAGS} $(FLAGS_CHECK)

MPIFCCOMPILE_CHECK = ${MPIFC} ${FCFLAGS} $(FLAGS_CHECK)

CC = icc
CFLAGS = 
CPPFLAGS = -I${SETUP}  -DFORCE_VECTORIZATION
```

setup for benchmark runs:
```
sed -i "s:DO_BENCHMARK_RUN_ONLY.*:DO_BENCHMARK_RUN_ONLY = .true.:g" setup/constants.h
```

fixes the number of time steps to 300.


#### Run setup

weak scaling:
```
./setup_weakscaling.pl 2 GPU
./setup_weakscaling.pl 4 GPU
./setup_weakscaling.pl 8 GPU
./setup_weakscaling.pl 12 GPU
./setup_weakscaling.pl 16 GPU
```


strong scaling:
```
./setup_strongscaling.pl 2 GPU
./setup_strongscaling.pl 4 GPU
./setup_strongscaling.pl 8 GPU
./setup_strongscaling.pl 16 GPU
```

note: strong scaling `./setup_strongscaling.pl 4 GPU` will have the same setup as the weak scaling example `./setup_weakscaling.pl 4 GPU`
      with NEX = 256


#### See results in the scratch work directory

for example:
```
cd ${SCRATCH}/RUN/CPUStrong96/
```
