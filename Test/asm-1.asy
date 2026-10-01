import graph3;
import palette;

size(300, 300, IgnoreAspect);

// Setup the 3D camera orientation
currentprojection = perspective(camera=(6, -8, 5), target=(0, 0, 2.5));

// Approximation of the Gamma function for real/complex variables using Lanzcos approximation
real gamma_mag(real x, real y) {
    // Basic implementation of Lanczos approximation for complex magnitude
    // To keep the code lightweight, we can also use a simplified Stirling or standard product approximation,
    // or interface with a numeric library if compiled with it.
    // For this visual script, we cap values to prevent asymptote explosion.
    
    // Using an analytical approximation for |Gamma(z)|
    // For demonstration, a standard math function approximation or a simplified form:
    real r2 = x*x + y*y;
    if (r2 < 0.01) return 5.0; // Cap near the pole at z=0
    
    // Stirling's approximation for absolute value magnitude |Gamma(z)|
    // |z^z * e^-z * sqrt(2*pi/z)|
    real r = hypot(x, y);
    real theta = atan2(y, x);
    
    real log_mag = x * log(r) - y * theta - x + 0.5 * log(2 * pi) - 0.5 * log(r);
    real mag = exp(log_mag);
    
    // Cap the output height for a clean 3D render
    return min(mag, 5.0);
}

// Define the surface function mapping (x, y) -> (x, y, |Gamma(z)|)
triple f(pair p) {
    real x = p.x;
    real y = p.y;
    real z = gamma_mag(x, y);
    return (x, y, z);
}

// Define the domain boundaries (focusing on the complex origin and poles)
pair min_bounds = (-3.5, -2.0);
pair max_bounds = (2.0, 2.0);

// Generate the surface mesh
surface s = surface(f, min_bounds, max_bounds, nu=60, nv=60);

// Color the surface based on its height (magnitude)
s.colors(palette(s.map(zpart), Rainbow()));

// Draw the components
draw(s, render(merge=true));

// Add standard 3D Axes
xaxis3("$Re(z)$", Bounds, InTicks, Arrow3);
yaxis3("$Im(z)$", Bounds, InTicks, Arrow3);
zaxis3("$|\Gamma(z)|$", Bounds, InTicks, Arrow3);
