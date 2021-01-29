#!/usr/bin/gnuplot -persist
set terminal pngcairo enhanced size 800,600  font "Arial,11" 
set output 'weak-scaling-Summit-CPU.png'

# line styles
# for line with spacing around points
#set style line 1 linecolor rgb "#bb3333" lt 1 lw 1.8 pt 7 pointinterval -1 pointsize 1.2
#set style line 1 linecolor rgb "#bb3333" lt 1 lw 1.8 pt 7 pointinterval -1 pointsize 1.2
set style line 1 lt 1 lw 1.8 pt 7 pointinterval -1 pointsize 1.2
set style line 3 lt 3 lw 1.8 pt 7 pointinterval -1 pointsize 1.2
set pointintervalbox 2 
# for boxes
set style line 2 linecolor rgb "#3333bb"
set boxwidth 0.02
#set style fill solid border lt -1
set style fill transparent solid 0.8 noborder 

# axes
#set ylabel "Average run time per timestep (s)\n(for load w/ 31968 elements per slice)" 
set ylabel "Average run time* per timestep (s)"

set y2label "Number of grid elements per slice" 

set xlabel "Number of nodes"
##set x2label "Number of GPUs"

#set yrange [ 0.001 : 0.004] 
set yrange[0.0001:0.2]

set y2range [ 0.00000 : 150000 ] 

set ytics nomirror 
set xtics nomirror 
##set x2tics         
set y2tics (0,50000,100000)

set logscale x 10
##set logscale x2 10 
set logscale y 10

#set key top left
set key at 2000,0.05 

# reference simulation number of elements
N = 31968

# weak scaling
g(x) = 7.20e-8*N

# to compare GPU and CPU-only, we need to keep the load per node fix rather than the load per process.
# we will run 32 cores on the CPU, while only 6 processes per node for the GPU.
# thus the load per node is 32 / 6 = 5.3333 times bigger for the CPU simulation.
# either, we will run multiple processes on a single GPU to increase the load, or correct the CPU simulation time.
# thus:
#   Ncpu = N / (32/6) = N / 5.3333333 = 31968 / 5.33333 = 5994
Ncpu = 5994

#set xrange[50:10000]

##set x2range[8:2200]
set xrange[8:2200]

set grid

#set autoscale xfix
#set autoscale x2fix

## 2 axis
#plot 'weak-scaling-dec2018.dat' u 1:($5*N):x2tic(2):xtic(1) w lp ls 1 t 'Summit', \
#     7.20e-8*N lt 0 t 'ideal', \
#     '' u 1:4 w boxes ls 2 axes x1y2 t 'elem per slice'


plot 'weak-scaling-dec2018.dat' u 1:($5*N):xtic(1) w lp ls 1 t 'Summit', \
     'weak-scaling-jan2019-cpu.dat' u 1:(($5/$4/300.0)*Ncpu) index 0 w lp ls 3 t 'CPU-only Summit', \
     g(x) lt 0 t 'ideal', \
     g(x)*42 lt -1 dt 4 lw 1.0 t '42 x ideal', \
     'weak-scaling-dec2018.dat' u 1:4 w boxes ls 2 axes x1y2 t 'elem per slice'


