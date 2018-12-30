#!/usr/bin/gnuplot -persist
set terminal png enhanced medium butt
set output 'strong-scaling-Summit-efficiency.png'

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

plot [10:2500] 'strong-scaling-dec2018.dat' u 1:(d($1,$3)) w lp t 'Summit',100.0 lt 0 t 'ideal'

