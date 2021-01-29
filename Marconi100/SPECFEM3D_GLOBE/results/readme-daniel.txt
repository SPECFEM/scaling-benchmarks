---------------------
readme
---------------------

Marconi100: IBM AC922 system w/ 4 GPUs V100 per node
                                2 x 16 Power9 CPU-cores per node
                                256 GB DRAM

since the system and in particular the GPUs are very similar to Summit, 
the following benchmarks were done on Summit using 4 GPUs per node:




weak scaling performance
----------------------------------------------------------------------

setup:

global simulation

DO_BENCHMARK_RUN_ONLY = .true.
time steps: 300


- NPROC 24:
#BSUB -nnodes 6
jsrun -n24 -r4 -g1 -a1 -c1 ./bin/xspecfem3D
NPROC_XI = NPROC_ETA = 2   -> 24 procs
NEX_XI   = NEX_ETA   = 128
total elements per slice =  38464
GPU memory usage: used = 1257.812500 MB
Estimated total run time in seconds =  0.859280003999999487


- NPROC 96:
#BSUB -nnodes 24
jsrun -n96 -r4 -g1 -a1 -c1 ./bin/xspecfem3D
NPROC_XI = 4   -> 96 procs
NEX_XI   = 256
total elements per slice =  47040
GPU memory usage: used = 1439.562500 MB
Estimated total run time in seconds =  1.02485401299999879


- NPROC 384:
#BSUB -nnodes 96
jsrun -n384 -r4 -g1 -a1 -c1 ./bin/xspecfem3D
NPROC_XI = 8   -> 384 procs
NEX_XI   = 384
total elements per slice =  42552
GPU memory usage: used = 1349.562500 MB
Estimated total run time in seconds =  0.929909108999999567


- NPROC 864:
#BSUB -nnodes 216
jsrun -n864 -r4 -g1 -a1 -c1 ./bin/xspecfem3D
NPROC_XI = 12 -> 864 procs
NEX_XI   = 576
total elements per slice =  54180
GPU memory usage: used = 1633.562500 MB
Estimated total run time in seconds =  1.16417000200000054


- NPROC 1536:
#BSUB -nnodes 384
jsrun -n1536 -r4 -g1 -a1 -c1 ./bin/xspecfem3D
NPROC_XI = 16 -> 1536 procs
NEX_XI   = 640
total elements per slice =  37825
GPU memory usage: used = 1231.562500 MB
Estimated total run time in seconds =  0.870016971000000083



strong scaling performance
----------------------------------------------------------------------

setup:

global simulation
NEX = 256

DO_BENCHMARK_RUN_ONLY = .true.
time steps: 300


- NPROC 24:
#BSUB -nnodes 6
jsrun -n24 -r4 -g1 -a1 -c1 ./bin/xspecfem3D
NPROC_XI = 2 -> 24 procs
NEX_XI   = 256
total elements per slice =  188160
GPU memory usage: used = 4715.562500 MB
Estimated total run time in seconds =  3.79216353600000389

- NPROC 96: (same as weak scaling test)
#BSUB -nnodes 24
jsrun -n96 -r4 -g1 -a1 -c1 ./bin/xspecfem3D
NPROC_XI = 4   -> 96 procs
NEX_XI   = 256
total elements per slice =  47040
GPU memory usage: used = 1439.562500 MB
Estimated total run time in seconds =  1.02485401299999879

- NPROC 384:
#BSUB -nnodes 96
jsrun -n384 -r4 -g1 -a1 -c1 ./bin/xspecfem3D
NPROC_XI = 8 -> 384 procs
NEX_XI   = 256
total elements per slice =  11760
GPU memory usage: used = 623.625000 MB
Estimated total run time in seconds =  0.333605903000000037

- NPROC 1536:
#BSUB -nnodes 384
jsrun -n1536 -r4 -g1 -a1 -c1 ./bin/xspecfem3D
NPROC_XI = 16 -> 1536 procs
NEX_XI   = 256
total elements per slice =  2940
GPU memory usage: used = 411.562500 MB
Estimated total run time in seconds =  0.191929146000000106



----------------------

strong scaling with multiple MPI per GPU:

** 4 MPI process per node:
- NPROC 384:
#BSUB -nnodes 24
jsrun -n96 -r4 -g1 -a4 -c4 ./bin/xspecfem3D
NPROC_XI = 8 -> 384 procs
NEX_XI   = 256
total elements per slice =  11760
GPU memory usage: used = 2483.625000 MB
Estimated total run time in seconds =  1.02775629299999993       

-> compared to 4 x 0.333 = 1.334 
   MPS is 1.29x faster 

** 2 MPI process per node:
- NPROC 384:
#BSUB -nnodes 48
jsrun -n192 -r4 -g1 -a2 -c2 ./bin/xspecfem3D
NPROC_XI = 8 -> 384 procs
NEX_XI   = 256
total elements per slice =  11760
GPU memory usage: used = 1261.625000 MB
Estimated total run time in seconds =  0.566228977000000189      - compared to 2 x 0.333 = 0.666

-> compared to 2 x 0.333 = 0.666
   MPS is 1.17x faster


** 1 MPI process per node (from strong scaling above):
- NPROC 384:
#BSUB -nnodes 96
jsrun -n384 -r4 -g1 -a1 -c1 ./bin/xspecfem3D
NPROC_XI = 8 -> 384 procs
NEX_XI   = 256
total elements per slice =  11760
GPU memory usage: used = 623.625000 MB
Estimated total run time in seconds =  0.333605903000000037


--------------------------



preferred setup:

- NPROC  96, on 24 nodes (1 MPI process per node) -> time per time step = 1.02485401299999879 / 300
- NPROC 384, on 24 nodes (4 MPI process per node) -> time per time step = 1.02775629299999993 / 300

-> node hours: 
simulation for 180 min takes 67600 time steps, on 24 nodes, in hours:
1.02485401299999879 / 300 * 67600. * 24. / 60. / 60. = 1.54 hours

adjoint simulation: 2 x forward = 3.08 hours 

-> anelastic/elastic kernels: 1 forward + 1 adjoint (elastic) + 1 adjoint (anelastic) = 1.54 h + 3.08 h + 3.08 h = 7.7 h


marconi total core-hours = 352 * node-hours

total costs:

* 300 events
  20 iterations

  example for pure runtime costs:
  300 * 7.7 * 20 * 352. = 16262400.0 =  16 M core-hours

* 500 events
  20 iterations + 5 (psf tests) anelastic iterations
  10 iterations + 5 (psf tests) elastic anisotropy iterations

  anelastic 7.7 h node-hours   ( 1.54 + 3.08 + 3.08 )
  elastic   4.62 h node-hours  ( 1.54 + 3.08 )

  margins for : 
     post-processing: 
       smoothing (gradients on 384 cores -> 5 h per parameter; 5 parameters total -> 9500 core-hours)
       summation ( 30 min -> 260 core-hours)
       -> total for each iteration about 10,000 core-hours  -> 10000 / (2 * 16) node-hours = 312.5 node-hours

       line search: about additional 3 forward simulations for 50 selected events
                    -> 50 * 3 * 1.54 node-hours = 231 node-hours

     pre-processing:
       263 events, 2 period-bands
         filtering: observed    50 nodes, 16-cores -> 7 h
                    synthetics  50 nodes, 16-cores    20 min
         window selection:      50 nodes, 16-cores    1 h
         adjoint sources:       20 nodes, 16-cores    33 min
         weighting:                       12-cores    4 min
         summing:                         55-cores    18 min

       for 1 event: obs/syn preprocess   560 + 30 cpu-min
                    windowing                  80
                    adjoint sources            32
                    double-difference adj     144
                                  ->   total   14.1 core-hours  -> 14.1 / (2 *16) node-hours (2 x 16-cores per node) = 0.44 node-hours

     not quite clear how to add these costs since they only use CPU not GPUs, but probably would need to be done on Marconi100 as well,
     thus reserving a full node would lead to node-hours which then count as 352 * node-hours of these costs?


  note: probably i made a mistake when using 4.85 node-hours for elastic runs, 
        by adding 0.23 node-hours for elastic runs: 4.62 + 0.23 = 4.85  node-hours 

        however, using undo_att will lead to file i/o which is not accounted for the benchmark costs above 
        and thus the estimated run-times are likely too optimistic.

        file i/o is more costly for writing than reading, 
        so adding an additional 0.23 is likely still underestimating the final runtimes.


  note: post-processing per event: 312.5 / 500 -> 0.625 node-hours per event
                                   231   / 500 -> 0.462 node-hours 
        pre-postprocessing per event:             0.44 node-hours per event

        smoothing will be ported onto GPUs to cut-down post-processing times      


  estimated pre/post-processing costs per event:  elastic 4.85 + 0.15 = 5 node-hours 
                                                 anelastic 7.7 + 0.3  = 8 node-hours

  total costs:
    500 * (8) * (20 + 5) * 352 
  + 500 * (5) * (10 + 5) * 352 = 48.4 M core-hours







