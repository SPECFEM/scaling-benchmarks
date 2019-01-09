#!/opt/local/bin/gnuplot -persist
#
set terminal pngcairo enhanced font 'arial,11'
set output 'scaling-mpi-per-gpu.png'

# for line with spacing around points
set style line 1 lt 1 lw 1.8 pt 7 pointinterval -1 pointsize 1.2
set style line 2 linecolor rgb "#bbbbbb" lt 1 lw 1.8 pt 6 pointinterval -1 pointsize 1.2
set pointintervalbox 2 

set xlabel "Number of MPI processes per GPU" 
set ylabel "Average run time per timestep (s)" 

set key top left

#set offsets 1, 1, 0.2, 0.2
#show offsets

set xrange[0.8:11]

# number of time steps of simulation
N = 300

# ideal scaling
# from first run
i(x) = 1.08/N * x

# efficiency
# ideal: 100 percent
d(x,y) = 100.0 / ( y/i(x) )

set y2tics
set y2label 'Scaling efficiency (%)'

set logscale xy
set xtics nomirror
set ytics nomirror

set xtics (1,2,4,6,8)

plot 'scaling-mpi-per-gpu.dat' u 1:($2/N) w lp ls 1 t 'Summit - NEX 256 w/ 96 MPI processes total',i(x) w l lt 0 t 'ideal','' u 1:(d($1,$2/N)) axes x1y2 w lp ls 2 t 'efficiency'



