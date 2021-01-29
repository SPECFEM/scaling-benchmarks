#!/usr/bin/perl -w
#
#
# usage:
#    ./setup_strongscaling.pl 4 GPU [1] [0]

if( @ARGV < 1 ){
  die( "Usage:  ./setup_strongscaling.pl nproc_xi GPU [1==submit] [1==test-only] \n\n");
}

# arguments
$maxCPUs = $ARGV[0];
# GPU simulation
$GPU = "";
if( @ARGV > 1 ){ $GPU = $ARGV[1]; }
# automatic job submission
$do_sub = 0;
if( @ARGV > 2 ){ $do_sub = $ARGV[2]; }
# no compilation, only run script setup
$test_only = 0;
if( @ARGV > 3 ){ $test_only = $ARGV[3]; }

###################################################

# NEX TOTAL
$NEX_TOTAL = 256; # 160; # 256; # 512; #600; #2400;

# cluster name
$SYSTEM_NAME = $ENV{'SYSTEM_NAME'}; # "summit", "titan", ..

$SYSTEM_NAME = "marconi100"; # marconi100 tests on summit

if( $SYSTEM_NAME eq ""){ $SYSTEM_NAME = "<not recognized>";}

# absolute home/run directory
## summit / titan
$HOMEDIR = $ENV{'HOME'}; #"/ccs/home/dpeter";
$RUNDIR = $ENV{'SCRATCH'}; # titan: "/lustre/atlas/scratch/dpeter/geo111"; # summit: /gpfs/alpine/csc190/scratch/dpeter # daint: "/scratch/daint/dpeter";

# main/template directory
#$maindir = "${HOMEDIR}/benchmark-scripts";
$maindir = "${HOMEDIR}/SPECFEM3D_GLOBE/daniel/benchmarks";

# source code directory
$sourcedir = "${HOMEDIR}/SPECFEM3D_GLOBE";

# working directory
$workdir = "${RUNDIR}";

# datadirectory
$datadir = "${RUNDIR}/DATA";

# processes per node
if( $SYSTEM_NAME eq "summit"){
  ## summit:
  # gpu node: 2x21-core Power9, 6 GPU Volta V100 per node
  $ppn_gpu = 6;
  $ppn_cpu = 32; # 42; total, but usable with nex numbers better 32 per node -> 16 cores per chip
} elsif( $SYSTEM_NAME eq "titan"){
  ## titan:
  # gpu node: 16-core AMD opteron, 1 GPU Kepler K20x
  # https://www.olcf.ornl.gov/for-users/system-user-guides/titan/system-overview/
  $ppn_gpu = 1;
  $ppn_cpu = 16;
} elsif( $SYSTEM_NAME eq "daint"){
  ## daint:
  # gpu node: 12-core haswell, 1 GPU Pascal P100
  # cpu node: 2 x 18-core broadwell
  $ppn_gpu = 1;
  $ppn_cpu = 12; # 8;
} elsif( $SYSTEM_NAME eq "marconi100"){
  ## marconi100
  # gpu node: 2x21-core Power9, 4 GPU Volta V100 per node
  $ppn_gpu = 4;
  $ppn_cpu = 32; # 42; total, but usable with nex numbers better 32 per node -> 16 cores per chip
}else{
  # not recognized, generic
  $ppn_gpu = 1;
  $ppn_cpu = 16;
}

# CPU increment
#$incr = 1;

# minimum number of CPU cores to start
#$minCPUs = 1;

# global simulation
$nchunks = 6;

# cluster / job-script
if( $SYSTEM_NAME eq "summit"){
  ## summit
  $PBS = 2; #uses LSF bsub
  $jobscript = "go_benchmark.summit.bash";
  $makescript = "mk_summit.sh";
} elsif( $SYSTEM_NAME eq "titan"){
  ## titan
  $PBS = 1; # uses qsub
  $jobscript = "go_benchmark.titan.bash";
  $makescript = "mk_titan.sh";
} elsif( $SYSTEM_NAME eq "daint"){
  ## daint
  $PBS = 0; #uses slurm sbatch
  $jobscript = "go_benchmark.sbatch";
  $makescript = "mk_daint.sh";
} elsif( $SYSTEM_NAME eq "marconi100"){
  ## marconi100
  $PBS = 2; #uses LSF bsub
  $jobscript = "go_benchmark.summit.bash"; # test on summit
  $makescript = "mk_summit.sh";
} else{
  # todo
  die("Error: system with SYSTEM_NAME $SYSTEM_NAME has no scripts yet, please set up...");
}

###################################################

print "system: $SYSTEM_NAME\n";
print "setup : $GPU\n";

# sets processes per node
if( $GPU eq "GPU"){
$ppn = $ppn_gpu;
}else{
$ppn = $ppn_cpu;
}
print "  processes per node used: $ppn \n";

# greates common divisor
sub gcd($$) {
  my ($u, $v) = @_;
  while ($v) {
    ($u, $v) = ($v, $u % $v);
  }
  return abs($u);
}

$currentdir = `pwd`;
chomp($currentdir);

# increment == 1, then:
# 2->cpus=1,2
# 4->cpus=1,2,3,4

$j = int( $maxCPUs * $maxCPUs );
# or loop instead...
#for($j=1;$j<=$maxCPUs;$j=$j+$incr){

  # uses square-root to have xmeshfem3D creating mesh
  $nproc1 = int( sqrt($j) );

  # finds setup for nproc_xi and nproc_eta
  $n = gcd($j,$nproc1);
  $nproc1 = $n;
  $nproc2 = int( $j / $nproc1 );

  $cpus = $nproc1 * $nproc2 * $nchunks ;
  print "\nprocesses: $cpus \n";
  print "  nproc_1: $nproc1 nproc_2: $nproc2 \n";
  print "  nex    : $NEX_TOTAL \n";

  # xmeshfem3d required nex is multiple of nproc for
  # strong scaling mesh
  if( $NEX_TOTAL % ($nproc1*8) != 0 ){ print "nex not a multiple of 8 * nproc_1, skipping strong scaling...\n"; next;  }
  if( $NEX_TOTAL % ($nproc2*8) != 0 ){ print "nex not a multiple of 8 * nproc_2, skipping strong scaling...\n"; next;  }

  # evaluates number of nodes needed
  $nodes = $cpus % $ppn ;
  if( $nodes == 0 ){
    # round number of nodes
    $nodes =  $cpus / $ppn ;
  }
  else{
    # increase to the next higher number of nodes
    $nodes = ( $cpus - $nodes ) / $ppn + 1;
  }
  print "\n  nodes requested: $nodes \n";


  # creates new directory in RUN
  $newdir = "$workdir/RUN/CPUstrong$cpus";
  if( ! -e "$workdir/RUN" ){system("mkdir -p $workdir/RUN");}

  # clean-up
  if( $test_only == 1){
    print "\nTEST ONLY! no clean-up...\n\n";
  }else{
    if( -e "$newdir" ){system("rm -rf $newdir/*");}
  }

  # cleans OUTPUTS/
  #-----------------
  #if(-e "$maindir/OUTPUTS/OUTPUT_FILES.$cpus"){system("rm -rf $maindir/OUTPUTS/OUTPUT_FILES.$cpus");}

  # sets up new directoy
  system("mkdir -p $newdir");
  system("mkdir -p $newdir/DATA");
  system("mkdir -p $newdir/bin");
  system("mkdir -p $newdir/OUTPUT_FILES");
  system("mkdir -p $newdir/DATABASES_MPI");

  # copy binaries
  #system("cp -p $maindir/bin/xmeshfem3D $newdir/bin/");
  #system("cp -p $maindir/bin/xspecfem3D $newdir/bin/");

  # copy scripts
  system("cp -p $maindir/$jobscript $newdir/$jobscript");

  # copy backup of Par_file,STATIONS and src
  system("cp -p $maindir/DATA/Par_file $newdir/DATA/");
  system("cp -p $maindir/DATA/STATIONS $newdir/DATA/");
  system("cp -p $maindir/DATA/CMTSOLUTION $newdir/DATA/");

  # modify Par_file and script
  chdir($newdir) or die("change to $newdir failed");

  # replace NPROC_XI & NPROC_ETA by actual number of CPUs
  system("sed -i 's:^NPROC_XI.*:NPROC_XI                          = $nproc1 :' DATA/Par_file");
  system("sed -i 's:^NPROC_ETA.*:NPROC_ETA                         = $nproc2 :' DATA/Par_file");

  # replace NEX_XI & NEX_ETA by actual number of CPUs
  $nex = $NEX_TOTAL;
  print "  nex = $nex\n\n";
  #print "  nex_per_proc = ",$nex/$nproc1,"\n";
  #print "  nex_total per_proc = ",($nex/$nproc1)*($nex/$nproc2),"\n";

  system("sed -i 's:^NEX_XI.*:NEX_XI                          = $nex:' DATA/Par_file");
  system("sed -i 's:^NEX_ETA.*:NEX_ETA                         = $nex:' DATA/Par_file");

  # use GPU mode
  if( $GPU eq "GPU"){
    system("sed -i 's:^GPU_MODE .*:GPU_MODE                        = .true. :' DATA/Par_file");
  }else{
    system("sed -i 's:^GPU_MODE .*:GPU_MODE                        = .false. :' DATA/Par_file");
  }

  # compiles binaries
  chdir($sourcedir) or die("change to $sourcedir failed");

  if( $test_only == 1){
    print "\nTEST ONLY! no compilation...\n\n";
  }else{
    system("cp -p $newdir/DATA/Par_file ./DATA/");
    system("rm -f $newdir/bin/*");
    # check with setup_benchmark script
    #system("sed -i 's:DO_BENCHMARK_RUN_ONLY .*:DO_BENCHMARK_RUN_ONLY = .true.  :' setup/constants.h");
    #system("sed -i 's:USE_MESH_COLORING_GPU .*:USE_MESH_COLORING_GPU = .false. :' setup/constants.h");
    #system("sed -i 's:#define USE_MESH_COLORING_GPU:#undef USE_MESH_COLORING_GPU:' src/gpu/mesh_constants_gpu.h");
    #system("sed -i 's:#define ENABLE_VERY_SLOW_ERROR_CHECKING .*:#define ENABLE_VERY_SLOW_ERROR_CHECKING 0:' src/gpu/mesh_constants_gpu.h");
    # compilation
    system("./$makescript 1");
    if( ! -e "./bin.forward/xspecfem3D" ){die("compilation in $sourcedir failed, please check...");}
    system("cp -p ./bin.forward/* $newdir/bin/");
    # backup setup files
    system("cp -p ./Makefile $newdir/bin/");
    system("cp -p ./setup/constants.h $newdir/bin/");
    if( $GPU eq "GPU"){system("cp -p ./src/gpu/mesh_constants_gpu.h $newdir/bin/");}
  }

  chdir($newdir) or die("change to $newdir failed");

  # sets up DATA/ model link
  chdir("$newdir/DATA") or die("change to $newdir/DATA failed");
  system("ln -s $datadir/crust2.0");
  system("ln -s $datadir/QRFSI12");
  system("ln -s $datadir/s362ani");
  system("ln -s $datadir/topo_bathy");

  chdir($newdir) or die("change to $newdir failed");

  # replace job-nodes by rounded number of nodes
  system("sed -i 's/^NPROC=.*/NPROC=$cpus/g' $jobscript");

  if( $GPU eq "GPU"){
    print "  setting gpu simulation:\n";
    if( $PBS == 1 ){
      # PBS
      print "  PBS scheduler\n";
      system("sed -i 's/^#PBS -l nodes=.*/#PBS -l nodes=$cpus/g' $jobscript");
      #system("sed -i 's/^#PBS -l feature=.*/#PBS -l feature=gpu/g' $jobscript");
      # 1 process per gpu: -N 1
      system("sed -i 's/^aprun -n \$NPROC/aprun -n \$NPROC -N 1/g' $jobscript");
    }elsif( $PBS == 2 ){
      # LSF
      print "  LSF scheduler\n";
      # 1 processes on 1 gpu
      system("sed -i 's/^#BSUB -nnodes .*/#BSUB -nnodes $nodes/g' $jobscript");
      system("sed -i 's/jsrun -n \$NPROC/jsrun -n$cpus -r$ppn -g1 -a1 -c1/g' $jobscript");
      #system("sed -i 's/jsrun -n \$NPROC .\/bin\/xspecfem3D/jsrun -n$ppn -g1 -a1 -c1 .\/bin\/xspecfem3D/g' $jobscript");
    }else{
      # SLURM
      print "  Slurm scheduler\n";
      # OpenCL: needs 1 process per gpu: -N 1
      system("sed -i 's/^#SBATCH --nodes=.*/#SBATCH --nodes=$cpus/g' $jobscript");
      system("sed -i 's/^#SBATCH --ntasks=.*/#SBATCH --ntasks=$cpus/g' $jobscript");
      system("sed -i 's/^#SBATCH --ntasks-per-node=.*/#SBATCH --ntasks-per-node=1/g' $jobscript");
      #system("sed -i 's/^srun -n \$NPROC/srun -n \$NPROC -N 1/' $jobscript");
      system("sed -i 's/^srun -n \$NPROC/srun /g' $jobscript");
      # CUDA Multiple-processes per gpu
      #system("sed -i 's/^#SBATCH --nodes=.*/#SBATCH --nodes=$nodes/' $jobscript");
      #system("sed -i 's/^#SBATCH --ntasks=.*/#SBATCH --ntasks=$cpus/' $jobscript");
      #system("sed -i 's/^aprun -n \$NPROC/aprun -n \$NPROC/' $jobscript");
    }
  }else{
    print "  setting no gpu simulation:\n";
    if( $PBS == 1 ){
      # PBS
      print "  PBS scheduler\n";
      system("sed -i 's/^#PBS -l nodes=.*/#PBS -l nodes=$nodes/g' $jobscript");
      #system("sed -i 's/^#PBS -l feature=.*/##PBS -l feature=gpu/g' $jobscript");
      system("sed -i 's/^aprun -n \$NPROC/aprun -n \$NPROC/g' $jobscript");
    }elsif( $PBS == 2 ){
      # LSF
      print "  LSF scheduler\n";
      system("sed -i 's/^#BSUB -nnodes .*/#BSUB -nnodes $nodes/g' $jobscript");
      # for summit cpu: best to put 16 cores on each chip by: -a 16 -c 16 -r 2 -l cpu-cpu -d packed -b packed:1
      $ppn2 = $ppn / 2;
      $nres = $cpus / $ppn2 ;
      system("sed -i 's/jsrun -n \$NPROC/jsrun -n$nres -r2 -g0 -a$ppn2 -c$ppn2 -l cpu-cpu -d packed -b packed:1/g' $jobscript");
      #
      #system("sed -i 's/jsrun -n \$NPROC/jsrun -n$cpus -r$ppn -g0 -a1 -c1/g' $jobscript");
      #system("sed -i 's/jsrun -n \$NPROC .\/bin\/xspecfem3D/jsrun -n$ppn -g0 -a1 -c1 .\/bin\/xspecfem3D/g' $jobscript");
    }else{
      # SLURM
      print "  Slurm scheduler\n";
      system("sed -i 's/^#SBATCH --nodes=.*/#SBATCH --nodes=$nodes/g' $jobscript");
      system("sed -i 's/^#SBATCH --ntasks=.*/#SBATCH --ntasks=$cpus/g' $jobscript");
      system("sed -i 's/^#SBATCH --ntasks-per-node=.*/#SBATCH --ntasks-per-node=$ppn/g' $jobscript");
      system("sed -i 's/^srun -n \$NPROC/srun -n \$NPROC/g' $jobscript");
    }
  }

  print "\nstrong scaling setup:\n";
  print "  nex (xi/eta): $nex / $nex\n";
  print "  nodes    : $nodes\n";
  print "  processes: $cpus\n\n";

  # launches job
  if( $do_sub == 1 ){
    print "submitting job:\n";
    if( $PBS == 1 ){
      # PBS
      system("qsub $jobscript");
    } elsif( $PBS == 2 ){
      # LSF
      system("bsub $jobscript");
    }else{
      # SLURM
      system("sbatch $jobscript");
    }
    print "\n";
    sleep(2);
  } else {
    if( $PBS == 1 ){
      # PBS
      print "to submit, type: qsub $jobscript\n";
    } elsif( $PBS == 2 ){
      # LSF
      print "to submit, type: bsub $jobscript\n";
    }else{
      # SLURM
      print "to submit, type: sbatch $jobscript\n";
    }
    print "\n";
  }
  print "  see work directory: $newdir/ \n";
  chdir($currentdir) or die("change to $currentdir failed");

# or loop on j...
#}

print "done\n";
