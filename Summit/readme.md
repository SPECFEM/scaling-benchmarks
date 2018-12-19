# Summit benchmarks

Summit:
https://www.olcf.ornl.gov/olcf-resources/compute-systems/summit/

system details:
- IBM Power System AC922 nodes, 4,600 nodes
- node: 2 IBM POWER9 CPU + 6 Nvidia Volta V100 (3 GPU V100 connected to one socket by nvlink each)
        NVLink 25GB/s bandwidth, 512 GB DDR4 memory, 96 GB HPM2 memory for accelerators, 1.6 TB burst buffer
        POWER9 CPU: 22 SMC cores, Simultaneous multi-threading (SMT) = hyperthreading up to 4 threads per core
- InfiniBand interconnect network
- Red Hat RHEL version 7.4

for compute job details see:
https://www.olcf.ornl.gov/for-users/system-user-guides/summit/running-jobs/#hardware-threads
https://jsrunvisualizer.olcf.ornl.gov


