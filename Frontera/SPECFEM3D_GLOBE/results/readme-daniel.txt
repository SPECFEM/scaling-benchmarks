---------------------
readme
---------------------

Frontera:
https://frontera-portal.tacc.utexas.edu/user-guide/system/

Frontera hosts 8,008 Cascade Lake (CLX) compute nodes:
  Intel Xeon Platinum 8280 ("Cascade Lake")
  56 cores on two sockets (28 cores/socket)
  192GB (2933 MT/s) DDR4 RAM

Frontera hosts 90 GPU nodes:
  4 NVIDIA Quadro RTX 5000 / node



weak scaling performance
----------------------------------------------------------------------

setup:

global simulation

DO_BENCHMARK_RUN_ONLY = .true.
time steps: 300

CPU-only nodes:
- NPROC 24:
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --ntasks-per-node=24
NPROC_XI = NPROC_ETA = 2   -> 24 procs
NEX_XI   = NEX_ETA   = 128
total elements per slice =  38464
Estimated total run time in seconds =    111.373443631455   

MPI pinning:
note: uses 24 mpi processes, thus the process pinning assigns 2-cores for each process (allowing to spread (OpenMP) threads).
      the default setup with I_MPI_PIN_ORDER=compact will fill up the first socket, leaving the second socket almost empty.
      with bunch, this will spread out evenly to both sockets.

      using more than 28 mpi processes per node, then the pinning assigns 1 core for each process.
      the default compact will then use both sockets evenly. so little/no difference to the bunch setup.

  with I_MPI_PIN_ORDER=bunch:
  Estimated total run time in seconds =    107.458383580670

  with I_MPI_PIN_DOMAIN=1:
  Estimated total run time in seconds =    108.300778580830

  with I_MPI_PIN_DOMAIN=1 & I_MPI_PIN_ORDER=bunch:
  Estimated total run time in seconds =    107.633250689134 



- NPROC 96:
#SBATCH --nodes=2
#SBATCH --ntasks=96
#SBATCH --ntasks-per-node=48
NPROC_XI = 4   -> 96 procs
NEX_XI   = 256
total elements per slice =  47040
Estimated total run time in seconds =    176.558749153279

- NPROC 384:
#SBATCH --nodes=8
#SBATCH --ntasks=384
#SBATCH --ntasks-per-node=48
NPROC_XI = 8   -> 384 procs
NEX_XI   = 384
total elements per slice =  42552
Estimated total run time in seconds =    153.763924910687

- NPROC 864:
#SBATCH --nodes=16
#SBATCH --ntasks=864
#SBATCH --ntasks-per-node=54
NPROC_XI = 12 -> 864 procs
NEX_XI   = 576
total elements per slice =  54180
Estimated total run time in seconds =    215.351388461888 

- NPROC 1536:
#SBATCH --nodes=32
#SBATCH --ntasks=1536
#SBATCH --ntasks-per-node=48
NPROC_XI = 16 -> 1536 procs
NEX_XI   = 640
total elements per slice =  37825
Estimated total run time in seconds =    135.759773090249
Estimated total run time in seconds =    139.768299592659  run 2
Estimated total run time in seconds =    200.647826354951  run 3
Estimated total run time in seconds =    140.194491927512  run 4

- NPROC 3456:
#SBATCH --nodes=64
#SBATCH --ntasks=3456
#SBATCH --ntasks-per-node=54
NPROC_XI = 24 -> 3456 procs
NEX_XI = 768
total elements per slice =        30464
Estimated total run time in seconds =    124.705156211043


- NPROC 6144:
#SBATCH --nodes=128
#SBATCH --ntasks=6144
#SBATCH --ntasks-per-node=48
NPROC_XI = 32 -> 6144 procs
NEX_XI = 1024
total elements per slice =        40640
Estimated total run time in seconds =    146.254489035578 


strong scaling performance
----------------------------------------------------------------------

setup:

global simulation
NEX = 256

DO_BENCHMARK_RUN_ONLY = .true.
time steps: 300


- NPROC 24:
fails memory allocation: #SBATCH --nodes=1
                         #SBATCH --ntasks=24
                         #SBATCH --ntasks-per-node=24
#SBATCH --nodes=2
#SBATCH --ntasks=24
#SBATCH --ntasks-per-node=12
NPROC_XI = 2 -> 24 procs
NEX_XI   = 256
total elements per slice =  188160
Estimated total run time in seconds =    474.284482282586

- NPROC 96: (same as weak scaling test)
#SBATCH --nodes=2
#SBATCH --ntasks=96
#SBATCH --ntasks-per-node=48
NPROC_XI = 4   -> 96 procs
NEX_XI   = 256
total elements per slice =  47040
Estimated total run time in seconds =    176.788225409575

- NPROC 384:
#SBATCH --nodes=8
#SBATCH --ntasks=384
#SBATCH --ntasks-per-node=48
NPROC_XI = 8 -> 384 procs
NEX_XI   = 256
total elements per slice =  11760
Estimated total run time in seconds =    45.1629759455100

- NPROC 1536:
#SBATCH --nodes=32
#SBATCH --ntasks=1536
#SBATCH --ntasks-per-node=48
NPROC_XI = 16 -> 1536 procs
NEX_XI   = 256
total elements per slice =  2940
Estimated total run time in seconds =    11.9457483720034

- NPROC 6144:
#SBATCH --nodes=128
#SBATCH --ntasks=6144
#SBATCH --ntasks-per-node=48
NPROC_XI = 32 -> 6144
NEX_XI   = 256
total elements per slice =          735
Estimated total run time in seconds =    3.39151705568656 




----------------------

# GPU simulations with default example: EXAMPLES/regional_Greece_small/

- GPU Turing: Device Quadro RTX 5000
  (Frontera: GPU node w/ 4 Quadro RTX 5000 per node, Intel CPU Broadwell)
  
  - default 4 mpi process total, 1 mpi process per card:
  Estimated total run time in seconds =    1.42402335861698  

  - 1 mpi process only (NPROC_XI == NPROC_ETA == 1):
  Estimated total run time in seconds =    4.95245108334348 


- CPU Cascade Lake
  (Frontera: Intel Xeon Platinum 8280 ("Cascade Lake"), 56 cores on two sockets (28 cores/socket) per node)

  - default 4 mpi process total:
  Estimated total run time in seconds =    119.564120456576


------------------------

# global simulation shakemovie w/ undo_att

- NPROC 384:
#SBATCH --nodes=8
#SBATCH --ntasks=384
#SBATCH --ntasks-per-node=48
NPROC_XI = 8 -> 384 procs
NEX_XI   = 256
 number of time steps:         2000
 undoing attenuation:
   total number of time subsets                     =            8
   wavefield snapshots at every NT_DUMP_ATTENUATION =          280
 Estimated total run time in seconds =    332.104221311864 


- NPROC 1536:
#SBATCH --nodes=32
#SBATCH --ntasks=1536
#SBATCH --ntasks-per-node=48
NPROC_XI = 8 -> 1536 procs
NEX_XI   = 256

** memory issue: ADIOS2 fails to open snapshot file for adjoint simulation
Error output:
..
std::bad_alloc
adios2_open_new_comm
..
 Error: process         1034  has ADIOS2 error            4
 Error message: 
 Error opening adios2 file ./DATABASES_MPI/save_forward_arrays_undoatt.bp
 ADIOS2 error
..


-> seems to be memory issue on the nodes, if not enough memory available.
   running the same simulation setup on 64 nodes instead of 32 doesn't fail.


** setup tested:
MEMORY_INSTALLED_PER_CORE_IN_GB = 4.d0
PERCENT_OF_MEM_TO_USE_PER_CORE  = 85.d0

-> xcreate_header_files:
 current record length is =    180.0000     min
 current minimum number of time steps will be =        67600

 Estimating optimal disk dumping interval for UNDO_ATTENUATION:
 *******************************************************************************
 
 without undoing of attenuation you are using   0.236826352000000      
  GB per core
   i.e.    5.920659     % of the installed memory
 
 each time step to store in memory to undo attenuation will require storing 
  2.435344000000000E-003  GB per core
 
 *******************************************************************************
 the optimal value is thus NT_DUMP_ATTENUATION =         1298
 *******************************************************************************
 
 we will need to save a total of           53  dumpings (restart files) to disk
 
 each dumping on the disk to undo attenuation will require storing 
  2.806069200000000E-002  GB per core
 
 each dumping on the disk will require storing    43.1012229120000      
  GB for all cores
 
 ALL dumpings on the disk will require storing    1.48721667600000      
  GB per core
 
 *******************************************************************************
 ALL dumpings on the disk will require storing    2284.36481433600      
  GB for all cores
   i.e.    2.28436481433600       TB

note:
  actual number of time steps for 180.0 min simulation will become 67,700 in the solver

test run of 5min:
 number of time steps:         2000
 undoing attenuation:
   total number of time subsets                     =            2
   wavefield snapshots at every NT_DUMP_ATTENUATION =         1298
 Estimated total run time in seconds =    82.4447984095896   

-> test run of 5min: adjoint simulation runs successfully

test run cancelled after 14000 steps:
 Time step #        14000
 Time:    37.25566      minutes
 Estimated total run time in seconds =    2768.70977952573 

test run of 180min:
-> adjoint simulation fails...


** setup tested: 
MEMORY_INSTALLED_PER_CORE_IN_GB = 4.d0
PERCENT_OF_MEM_TO_USE_PER_CORE  = 88.25d0
-> 1352 time steps per dump 
-> 51 dumpings for 67700 time steps, i.e., 180 min seismograms

test run cancelled after 9000 steps:
 Time step #         9000
 Time:    23.92233      minutes
 Estimated total run time in seconds =    2776.82651801569  


-> adjoint simulation fails...


** setup tested:
MEMORY_INSTALLED_PER_CORE_IN_GB = 4.d0
PERCENT_OF_MEM_TO_USE_PER_CORE  = 88.4d0
-> 1354 time steps per dump 
-> 50 dumpings for 67700 time steps, i.e., 180 min seismograms

Estimating optimal disk dumping interval for UNDO_ATTENUATION:
 *******************************************************************************
 
 without undoing of attenuation you are using   0.236826352000000      
  GB per core
   i.e.    5.920659     % of the installed memory
 
 each time step to store in memory to undo attenuation will require storing 
  2.435344000000000E-003  GB per core
 
 *******************************************************************************
 the optimal value is thus NT_DUMP_ATTENUATION =         1354
 *******************************************************************************
 
 we will need to save a total of           50  dumpings (restart files) to disk
 
 each dumping on the disk to undo attenuation will require storing 
  2.806069200000000E-002  GB per core
 
 each dumping on the disk will require storing    43.1012229120000      
  GB for all cores
 
 ALL dumpings on the disk will require storing    1.40303460000000      
  GB per core
 
 *******************************************************************************
 ALL dumpings on the disk will require storing    2155.06114560000      
  GB for all cores
   i.e.    2.15506114560000       TB

test run:
 after Time step #         9000
 Estimated total run time in seconds =    2850.05120334945 

 final Time step #        67700
 Estimated total run time in seconds =    3020.85181015555 


Writing the seismograms in parallel took    529.100074189715       seconds
 
 Time-Loop Complete. Timing info:
 Total elapsed time in seconds =    3550.24894507998     


-> adjoint simulation fails...


** setup tested:
MEMORY_INSTALLED_PER_CORE_IN_GB = 4.d0
PERCENT_OF_MEM_TO_USE_PER_CORE  = 50.0d0

-> forward simulation:
 Time step #        67700
 Estimated total run time in seconds =    2811.22388996370

-> adjoint simulation successful:
 Time step #        67700
 Estimated total run time in seconds =    7411.13453590521 


