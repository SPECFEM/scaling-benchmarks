#!/usr/bin/env python

import sys

if len(sys.argv) != 3: 
    print("usage: ./print-weakscaling.py time nelem")
    sys.exit(1)

tval = float(sys.argv[1])
nelem = int(sys.argv[2])

print("timing: ",tval)
print("nelem : ",nelem)

# weak scaling
# reference simulation number of elements
N = 47040

# weak scaling
#g = 7.20e-8 * N
g = 7.26e-08 * N

# strong scaling
#g2 = 3.79216353600000389 / 300.0 * 24 / x / 4


if nelem > 0:
    val = tval / 300.0  / nelem * N
else:
    val = tval / 300.0

# efficiency
eff = 100.0 / ( val / g )

print("")
print("time per time step = ",val)
print("efficiency         = ",eff)
print("ideal time         = ",g)
print("")

