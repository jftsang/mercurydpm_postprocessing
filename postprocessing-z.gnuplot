#!/usr/bin/gnuplot 
set term png size 1024,768
set output "printme.png"
set multiplot layout 3,1
set yrange [0:1]
plot "out.txt" using 3:2 with lines
plot "out.txt" using 7:2 with lines
plot "out.txt" using 4:2 with lines

