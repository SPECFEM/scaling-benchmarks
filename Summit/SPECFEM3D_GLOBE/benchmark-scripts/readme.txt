---------------------------------------------------------
README
---------------------------------------------------------


To run benchmarks, use:

1. compile binaries for simulations:

  > ./setup_benchmark_configuration.sh

  configurates setup files in code directory ~/SPECFEM3D_GLOBE

2. setup strong-scaling benchmark simulation working directories:

  > ./setup_strongscaling.py 4 GPU

  to submit job scripts:
  > ./setup_strongscaling.py 4 GPU 1

3. setup weak-scaling benchmark simulation working directories:

  > ./setup_weakscaling.py 4 GPU

  to submit job scripts:
  > ./setup_weakscaling.py 4 GPU 1


note:
- benchmark example based on: EXAMPLES/global_s362ani/

- summit: modules for compilations are loaded through ~/.bashrc_setup:

