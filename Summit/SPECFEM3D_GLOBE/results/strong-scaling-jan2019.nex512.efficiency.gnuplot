#!/usr/bin/gnuplot -persist
set terminal png enhanced medium butt
set output 'strong-scaling-Summit-NEX512-efficiency.png'

set logscale x 10
#set logscale y 10

set xlabel "Number of GPUs" 
set ylabel "Scaling efficiency (%)" 

set yrange[20:110]

# ideal scaling
# from first run - nex 256
f(x) = 0.0121 * 24 * 1 / x
# from first run - nex 512
g(x) = 0.020275 * 96 * 1 / x

# efficiency
# ideal: 100 percent
d1(x,y) = 100. / ( y / f(x) )
d2(x,y) = 100. / ( y / g(x) )

plot [10:10000] 'strong-scaling-dec2018.dat' u 1:(d1($1,$3)) w lp t 'Summit - NEX 256', 'strong-scaling-jan2019.nex512.dat' u 1:(d2($1,$3)) w lp t 'Summit - NEX 512',100.0 lt 0 t 'ideal'


