clc; clear; close;

%Exact solution
u = @(x, t) 2*sech(t) + x * tanh(t);

% Initial Condition
g = @(x) 2;

% the number of grid points
N = 13;

h_x = 1 / (N-1); h_t = 1 / 100;

% the values of x and t
x = 0:h_x:1; t = [0, h_t];

% Compute weight coefficents
A = zeros(N, N);

for i = 1:N
  for j = 1:N
    if i ~= j

      p = 1;
      for k = 1:N
        if k ~= i && k ~= j
          p = p * (x(i) - x(k)) / (x(j) - x(k));
        endif
      endfor
      A(i, j) = 1 / (x(j) - x(i)) * p;
    endif
  endfor
endfor

for i = 1:N
  s = 0;
  for k = 1:N
    if k ~= i
      s = s + 1 / (x(i) - x(k));
    endif
  endfor
  A(i, i) = s;
endfor

U = zeros(N, 2);

% Apply initial Condition
U(:, 1) = g(x);

%Start RK4 algorithm
F = @(t, U) x' - U .* (A*U);

k1 = h_t * F(t(1), U(:, 1));
k2 = h_t * F(t(1) + 0.5*h_t, U(:, 1) + 0.5*k1);
k3 = h_t * F(t(1) + 0.5*h_t, U(:, 1) + 0.5*k2);
k4 = h_t * F(t(1) + h_t, U(:, 1) + k3);

U(:, 2) = U(:, 1) + (1/6) * (k1 + 2*k2 + 2*k3 + k4);

% Final Results
U_exact = zeros(N, 2);
Error = zeros(N, 2);

for i = 1:N
  for j = 1:2
    U_exact(i, j) = u(x(i), t(j));
    Error(i, j) = abs(U(i, j) - U_exact(i, j));
  endfor
endfor

disp("DQM")
disp(U(:, 2));
disp("Exact");
disp(U_exact(:, 2));
disp("Error");
disp(Error(:, 2));

Exact_data = [x' U_exact(:, 2)];
save -ascii 'Exact0.1N7.txt' Exact_data

DQM_data = [x' U(:, 2)];
save -ascii 'DQM0.1N7.txt' DQM_data

