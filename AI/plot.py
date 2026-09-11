import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(0.1, 5, 400)
plt.plot(x, 1/x)
plt.axis("off")
plt.savefig("curve.svg")
