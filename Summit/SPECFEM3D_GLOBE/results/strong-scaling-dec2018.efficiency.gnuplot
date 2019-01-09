#!/usr/bin/gnuplot -persist
set terminal pngcairo enhanced size 800,600  font "Arial,11"
set output 'strong-scaling-Summit-efficiency.png'

# line styles
# for line with spacing around points
set style line 1 lt 1 lw 1.8 pt 7 pointinterval -1 pointsize 1.2
set style line 2 lt 2 lw 1.8 pt 7 pointinterval -1 pointsize 1.2
set pointintervalbox 2

set logscale x 10
#set logscale y 10

set xlabel "Number of GPUs" 
set ylabel "Scaling efficiency (%)" 

set yrange[20:110]

# ideal scaling
# from first run
f(x) = 0.0121 * 24 * 1 / x  

# efficiency
# ideal: 100 percent
d(x,y) = 100. / ( y / f(x) )

plot [10:2500] 'strong-scaling-dec2018.dat' u 1:(d($1,$3)) w lp ls 1 t 'Summit',100.0 lt 0 t 'ideal'

