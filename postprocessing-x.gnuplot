#!/usr/bin/gnuplot 
set term png size 1024,768
set output "printme.png"
set multiplot layout 3,3
set xrange [0:0.1]

# Density against x
set yrange [0:1]
set autoscale ymax
plot "out.txt" using 2:3 with lines title 'density'
plot "out.txt" using 2:3 with lines title 'density'

# Height of current against x
set yrange [0:1]
set autoscale ymax
plot "out.txt" using 2:10 with lines title 'height'

# Momentum against x
#set yrange [0:1]
#set autoscale ymax
#plot "out.txt" using 2:7 with lines title 'px'

# Velocity against x
set yrange [0:1]
set autoscale ymax
plot "out.txt" using 2:4 with lines title 'vx'
set autoscale ymin
set autoscale ymax
plot "out.txt" using 2:5 with lines title 'vy'
plot "out.txt" using 2:6 with lines title 'vz'

# Height vs velocity
set xrange [0:1]
set autoscale xmax 
set yrange [0:1]
set autoscale ymax
plot "out.txt" using 10:4 title 'vx against height' 

set autoscale ymin 
set autoscale ymax 
plot "out.txt" using 10:5 title 'vy against height' 
plot "out.txt" using 10:6 title 'vz against height' 
