#!/usr/bin/gnuplot -persist
set terminal pngcairo enhanced size 800,600  font "Arial,11" 
set output 'strongscaling-efficiency.png'

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
set ylabel "Scaling efficiency (%)" 
set xlabel "Number of nodes"

#set yrange [ 0.001 : 0.004] 
#set yrange[0.0001:0.2]
set yrange[20:110]


set ytics nomirror 
set xtics nomirror 

set logscale x 10
##set logscale x2 10 
#set logscale y 10

#set key top left
#set key at 1000,0.05 

# reference simulation number of elements
N = 47040 

# weak scaling
#g(x) = 7.20e-8*N

# strong scaling
g(x) = 3.79216353600000389 / 300.0 * 24 / x / 4
#g(x) = 1.02485401299999879 / 300.0 * 96 / x / 4

# efficiency
# ideal: 100 percent
#d1(x,y) = 100. / ( y / f(x) )
d2(x,y) = 100. / ( y / g(x) )

#set xrange[50:10000]

##set x2range[8:2200]
set xrange[1:1000]

set grid

#set autoscale xfix
#set autoscale x2fix

## 2 axis
#plot 'weak-scaling-dec2018.dat' u 1:($5*N):x2tic(2):xtic(1) w lp ls 1 t 'Summit', \
#     7.20e-8*N lt 0 t 'ideal', \
#     '' u 1:4 w boxes ls 2 axes x1y2 t 'elem per slice'


#plot 'strongscaling.dat' u 1:($5/300.0):xtic(1) w lp ls 1 t 'GPU-run', g(x) lt 0 t 'ideal'

# smooth results
plot 'strongscaling.dat' u 1:(d2($1,$5/300.0)):xtic(1) smooth cspline ls 1 t 'GPU-run','' u 1:(d2($1,$5/300.0)) w p ls 1 t '', 100 lt 0 t 'ideal



