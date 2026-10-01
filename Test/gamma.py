import mpmath as mp
import numpy as np

mp.mp.dps = 30
nx, ny = 70, 70                    # keep this modest — see note below
xs = np.linspace(-4.5, 2.0, nx)    # Re(z)
ys = np.linspace(-4.0, 4.0, ny)    # Im(z)
zmax = 6.0                         # cap, so poles become flat-topped spikes

with open("gamma.dat", "w") as f:
    for x in xs:
        for y in ys:
            val = min(float(abs(mp.gamma(mp.mpc(x, y)))), zmax)
            f.write(f"{x:.5f} {y:.5f} {val:.5f}\n")
        f.write("\n")             # blank line between rows: pgfplots matrix format
