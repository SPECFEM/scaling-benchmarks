#!/opt/local/bin/gnuplot -persist
#
#    
#    	G N U P L O T
#    	Version 5.2 patchlevel 5    last modified 2018-10-06 
#    
#    	Copyright (C) 1986-1993, 1998, 2004, 2007-2018
#    	Thomas Williams, Colin Kelley and many others
#    
#    	gnuplot home:     http://www.gnuplot.info
#    	faq, bugs, etc:   type "help FAQ"
#    	immediate help:   type "help"  (plot window: hit 'h')
# set terminal x11  nopersist enhanced font "Arial,10"
# set output

set terminal png enhanced medium butt
set output 'strong-scaling-Summit-NEX512.png'

set logscale x 10
set logscale y 10

set xlabel "Number of GPUs" 
set ylabel "Average run time per time step (s)" 

# ideal scaling
# from first run
f(x) = 0.0121 * 24 * 1 / x  
# from NEX512 run
g(x) = 0.020275 * 96 * 1 / x

# NEX 512 is about a factor 6.85 more heavy than NEX 256:
#
# NEX 512 has number of elements per slice = 322560
# NEX 256 ..                               = 47040      -> leads to factor 322560./47040. = 6.857
#g(x) = 6.857 * f(x)

set datafile missing "-"

plot [10:10000] 'strong-scaling-dec2018.dat' u 1:3 w lp t 'Summit - NEX 256','strong-scaling-jan2019.nex512.dat' u 1:3 w lp t 'Summit - NEX 512',f(x) lt 0 t 'ideal', g(x) lt 0 t ''


