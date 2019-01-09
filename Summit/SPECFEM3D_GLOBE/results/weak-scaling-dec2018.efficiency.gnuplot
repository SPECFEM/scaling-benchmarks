#!/usr/bin/gnuplot -persist
set terminal pngcairo enhanced size 800,600  font "Arial,11"
set output 'weak-scaling-Summit-efficiency.png'

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
set ylabel "Scaling efficiency (%)" 

set y2label "Number of grid elements per slice"
set y2tics

set yrange[75:105]
set y2range [ 0.00000 : 100000 ] 

set xtics nomirror
set ytics nomirror
set logscale x 10

# reference simulation number of elements:
N = 31968

# ideal scaling
# from first run
#d0 = 7.48e-8 * N
# from second run
d0 = 7.20e-8 * N

# efficiency
# ideal: 100 percent
d(x) = 100. / ( x*N / d0 )

plot [50:5000] 'weak-scaling-dec2018.dat' u 1:(d($4)) w lp ls 1 t 'Summit',100.0 lt 0 t 'ideal','' u 1:3 w boxes ls 2 axes x1y2 t 'elem per slice'

