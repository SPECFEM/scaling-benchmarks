#!/usr/bin/gnuplot -persist
set terminal png enhanced font "Arial,11" 
set output 'weak-scaling-Summit.png'


set style line 1  linecolor rgb "#3333bb" 

set boxwidth 0.02
set style fill solid border lt -1

set xlabel "Number of GPUs" 
set ylabel "Average run time per timestep (s)\n(for load w/ 31968 elements per slice)" 

set y2label "number of elements per slice" 
set y2tics

set yrange [ 0.00000 : 0.004] 
set y2range [ 0.00000 : 100000 ] 

set ytics nomirror
set logscale x 10

# reference simulation number of elements
N = 31968

plot [50:5000] 'weak-scaling-dec2018.dat' u 1:3 w boxes ls 1 axes x1y2 t 'elem per slice','' u 1:($4*N) w lp lt 2 pt 6 t 'Summit',7.20e-8*N lt 0 t 'ideal'
