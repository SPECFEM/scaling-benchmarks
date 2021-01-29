#!/usr/bin/gnuplot -persist
set terminal pngcairo enhanced size 800,600  font "Arial,11" 
set output 'weak-scaling-Summit.png'

# line styles
# for line with spacing around points
set style line 1 linecolor rgb "#bb3333" lt 1 lw 1.8 pt 7 pointinterval -1 pointsize 1.2
set pointintervalbox 2 
# for boxes
set style line 2 linecolor rgb "#3333bb"
set boxwidth 0.02
set style fill solid border lt -1

# axes
#set ylabel "Average run time per timestep (s)\n(for load w/ 31968 elements per slice)" 
set ylabel "Average run time* per timestep (s)"

set y2label "Number of grid elements per slice" 
set y2tics

set xlabel "Number of nodes"
set x2label "Number of GPUs"

set yrange [ 0.001 : 0.004] 
set y2range [ 0.00000 : 100000 ] 

set ytics nomirror
set xtics nomirror 
set x2tics         

set logscale x 10
set logscale x2 10 

set key top left

# reference simulation number of elements
N = 31968

#set xrange[50:10000]

set x2range[8:2200]
set xrange[8:2200]

set grid

#set autoscale xfix
#set autoscale x2fix

plot 'weak-scaling-dec2018.dat' u 1:($5*N):x2tic(2):xtic(1) w lp ls 1 t 'Summit', \
     7.20e-8*N lt 0 t 'ideal', \
     '' u 1:4 w boxes ls 2 axes x1y2 t 'elem per slice'


