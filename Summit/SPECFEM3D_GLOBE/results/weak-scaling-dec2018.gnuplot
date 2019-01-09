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
set xlabel "Number of GPUs" 
set ylabel "Average run time per timestep (s)\n(for load w/ 31968 elements per slice)" 

set y2label "Number of grid elements per slice" 
set y2tics

set yrange [ 0.00000 : 0.004] 
set y2range [ 0.00000 : 100000 ] 

set xtics nomirror
set ytics nomirror
set logscale x 10

# reference simulation number of elements
N = 31968

plot [50:5000] 'weak-scaling-dec2018.dat' u 1:($4*N) w lp ls 1  t 'Summit',7.20e-8*N lt 0 t 'ideal','' u 1:3 w boxes ls 2 axes x1y2 t 'elem per slice'


