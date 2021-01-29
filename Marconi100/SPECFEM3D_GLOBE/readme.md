# Scaling Test Setup

Date: Oct. 26, 2020

benchmark for Marconi100 nodes: IBM AC922 system with 4 V100 GPUs per node
performed on Summit: IBM AC922 system with 6 V100 GPUs per node

#### Code setup

Modules loaded:
```
 1) hsi/5.0.2.p5   2) xalt/1.2.0   3) lsf-tools/2.0   4) DefApps   5) xl/16.1.1-6   6) spectrum-mpi/10.3.1.2-20200121   7) adios2/2.5.0   8) cuda/10.1.105
```


Makefile compilation flags:
```
FC = xlf90
FCFLAGS =
FC_DEFINE = -D
MPIFC = mpif90
MPILIBS =

FLAGS_CHECK = -qhalt=w -qsuppress=1518-318 -qsuppress=1518-234 -O3 -qstrict -DFORCE_VECTORIZATION
FCFLAGS_f90 = -qmoddir=./obj -I./obj -I.  -I. -I${SETUP}

CC = xlc
CFLAGS =
CPPFLAGS = -I${SETUP}  -DFORCE_VECTORIZATION

..

# CUDA
CUDA_FLAGS = -Xcompiler -Wall,-Wno-unused-function,-Wno-unused-const-variable
GENCODE = $(GENCODE_70) $(FC_DEFINE)GPU_DEVICE_Volta
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
