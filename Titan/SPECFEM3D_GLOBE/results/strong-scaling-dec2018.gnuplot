#!/usr/bin/gnuplot -persist
set terminal png enhanced medium butt
set output 'strong-scaling-Titan.png'

set logscale x 10
set logscale y 10

set xlabel "Number of GPUs" 

#set ylabel "Total elapsed time (s)" 
set ylabel "Average run time per time step (s)"

# from first run
#f(x) = 21.3082 * 24 * 1 / x
f(x) = 0.07102 * 24 * 1 / x

plot [10:500] 'strong-scaling-dec2018.dat' u 1:3 w lp t 'Titan',f(x) lt 0 t 'ideal'

