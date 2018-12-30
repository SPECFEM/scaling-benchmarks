#!/usr/bin/gnuplot -persist
set terminal png enhanced medium butt
set output 'strong-scaling-Summit.png'

set logscale x 10
set logscale y 10

set xlabel "Number of GPUs" 
set ylabel "Average run time per time step (s)" 

# ideal scaling
# from first run
f(x) = 0.0121 * 24 * 1 / x  

plot [10:2500] 'strong-scaling-dec2018.dat' u 1:3 w lp t 'Summit',f(x) lt 0 t 'ideal'

