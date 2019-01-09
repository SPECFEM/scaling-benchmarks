#!/usr/bin/gnuplot -persist
set terminal pngcairo enhanced size 800,600  font "Arial,11"
set output 'strong-scaling-Summit-NEX512-efficiency.png'

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
# from first run - nex 256
f(x) = 0.0121 * 24 * 1 / x
# from first run - nex 512
g(x) = 0.020275 * 96 * 1 / x

# efficiency
# ideal: 100 percent
d1(x,y) = 100. / ( y / f(x) )
d2(x,y) = 100. / ( y / g(x) )

plot [10:10000] 'strong-scaling-dec2018.dat' u 1:(d1($1,$3)) w lp ls 1 t 'Summit - NEX 256', 'strong-scaling-jan2019.nex512.dat' u 1:(d2($1,$3)) w lp ls 2 t 'Summit - NEX 512',100.0 lt 0 t 'ideal'


