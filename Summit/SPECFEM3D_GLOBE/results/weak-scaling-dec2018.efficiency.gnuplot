#!/usr/bin/gnuplot -persist
set terminal png enhanced font "Arial,11"
set output 'weak-scaling-Summit-efficiency.png'

#set border 3

set logscale x 10
#set logscale y 10

set xlabel "Number of GPUs" 
set ylabel "Scaling efficiency (%)" 

set style line 1  linecolor rgb "#3333bb"  

set boxwidth 0.02
set style fill solid border lt -1


set y2label "Number of grid elements per slice"
set y2tics
set y2range [ 0.00000 : 100000 ] 

set yrange[75:105]
set ytics nomirror

#set grid noxtics ytics

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

plot [50:5000] 'weak-scaling-dec2018.dat' u 1:3 w boxes ls 1 axes x1y2 t 'elem per slice','' u 1:(d($4)) w lp lt 2 pt 6 t 'Summit',100.0 lt 0 t 'ideal'

