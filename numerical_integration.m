%% ============================================================
%  NUMERICAL ANALYSIS — ASSIGNMENT 7
%  Numerical Integration of f(x) = x^2 + sin(5x) on [0, 5]
%
%  Methods implemented:
%    1) Left-Endpoint  Rectangle Rule
%    2) Right-Endpoint Rectangle Rule
%    3) Midpoint       Rectangle Rule
%    4) Trapezoidal    Rule
%
%  Each method is evaluated for n = 10, 50, 100, and 1000
%  subintervals. Results are compared against the analytical
%  solution and absolute errors are visualised on log-log axes.
%
%  Author : Aydan Aydemir
%  Date   : May 2026
%% ============================================================

clc; clear; close all;

%% ---------------------------------------------------------------
%  1. FUNCTION DEFINITION AND ANALYTICAL INTEGRAL
%% ---------------------------------------------------------------

% Integrand: f(x) = x^2 + sin(5x)
f = @(x) x.^2 + sin(5.*x);

% Integration limits
a = 0;   % lower bound
b = 5;   % upper bound

% Antiderivative: F(x) = x^3/3 - cos(5x)/5  (obtained analytically)
% Exact value: integral from 0 to 5 of f(x) dx = F(5) - F(0)
F       = @(x) x.^3 ./ 3 - cos(5.*x) ./ 5;
exact   = F(b) - F(a);

fprintf('================================================\n');
fprintf('  EXACT (ANALYTICAL) INTEGRAL VALUE: %.10f\n', exact);
fprintf('================================================\n\n');

%% ---------------------------------------------------------------
%  2. NUMERICAL COMPUTATION FOR EACH n VALUE
%% ---------------------------------------------------------------

n_values = [10, 50, 100, 1000];
num_cases = length(n_values);

% Pre-allocate result arrays
left_res   = zeros(1, num_cases);
right_res  = zeros(1, num_cases);
mid_res    = zeros(1, num_cases);
trap_res   = zeros(1, num_cases);

% Print results table header
fprintf('%-8s  %-14s  %-14s  %-14s  %-14s\n', ...
    'n', 'Left-Endpoint', 'Right-Endpoint', 'Midpoint', 'Trapezoidal');
fprintf('%s\n', repmat('-', 1, 74));

for k = 1:num_cases
    n = n_values(k);

    left_res(k)  = left_endpoint(f, a, b, n);
    right_res(k) = right_endpoint(f, a, b, n);
    mid_res(k)   = midpoint_rule(f, a, b, n);
    trap_res(k)  = trapezoidal(f, a, b, n);

    fprintf('%-8d  %-14.8f  %-14.8f  %-14.8f  %-14.8f\n', ...
        n, left_res(k), right_res(k), mid_res(k), trap_res(k));
end

%% ---------------------------------------------------------------
%  3. ABSOLUTE ERROR COMPUTATION
%% ---------------------------------------------------------------

left_err  = abs(left_res  - exact);
right_err = abs(right_res - exact);
mid_err   = abs(mid_res   - exact);
trap_err  = abs(trap_res  - exact);

fprintf('\n');
fprintf('%-8s  %-14s  %-14s  %-14s  %-14s\n', ...
    'n', 'Left Error', 'Right Error', 'Mid Error', 'Trap Error');
fprintf('%s\n', repmat('-', 1, 74));

for k = 1:num_cases
    fprintf('%-8d  %-14.2e  %-14.2e  %-14.2e  %-14.2e\n', ...
        n_values(k), left_err(k), right_err(k), mid_err(k), trap_err(k));
end

fprintf('\n');

%% ---------------------------------------------------------------
%  4. FIGURE 1 — Geometric Visualisation for n = 5
%     Left-endpoint rectangles (left panel) and trapezoids (right panel)
%     are drawn on top of the function curve, matching the style
%     shown in the assignment description.
%% ---------------------------------------------------------------

figure('Name', 'Geometric Visualisation (n = 5)', ...
       'Position', [100, 100, 1100, 450]);

n_demo  = 5;
h_demo  = (b - a) / n_demo;
x_fine  = linspace(a, b, 500);   % dense grid for the smooth curve

% --- Left subplot: Left-endpoint rectangles ---
subplot(1, 2, 1);
hold on; grid on;

plot(x_fine, f(x_fine), 'r-', 'LineWidth', 2);   % function curve

for i = 0 : n_demo - 1
    xi = a + i * h_demo;
    yi = f(xi);                                    % function value at left edge
    x_rect = [xi,      xi + h_demo, xi + h_demo, xi,      xi];
    y_rect = [0,       0,           yi,           yi,      0 ];
    fill(x_rect, y_rect, [0.55, 0.75, 0.95], ...
         'FaceAlpha', 0.45, 'EdgeColor', 'k', 'LineWidth', 1.2);
end

title('Left-Endpoint Rectangle Rule  (n = 5)', 'FontSize', 11);
xlabel('x',    'FontSize', 11);
ylabel('f(x)', 'FontSize', 11);
legend('f(x) = x^{2} + sin(5x)', 'Left-endpoint rectangles', ...
       'Location', 'northwest');

% --- Right subplot: Trapezoids ---
subplot(1, 2, 2);
hold on; grid on;

plot(x_fine, f(x_fine), 'r-', 'LineWidth', 2);   % function curve

for i = 0 : n_demo - 1
    xi  = a +  i      * h_demo;
    xi1 = a + (i + 1) * h_demo;
    yi  = f(xi);
    yi1 = f(xi1);
    x_trap = [xi,  xi1, xi1, xi,  xi];
    y_trap = [0,   0,   yi1, yi,  0 ];
    fill(x_trap, y_trap, [1.0, 0.78, 0.55], ...
         'FaceAlpha', 0.45, 'EdgeColor', 'k', 'LineWidth', 1.2);
end

title('Trapezoidal Rule  (n = 5)', 'FontSize', 11);
xlabel('x',    'FontSize', 11);
ylabel('f(x)', 'FontSize', 11);
legend('f(x) = x^{2} + sin(5x)', 'Trapezoids', ...
       'Location', 'northwest');

%% ---------------------------------------------------------------
%  5. FIGURE 2 — Error Convergence (log-log)
%     O(h)  convergence is expected for left- and right-endpoint rules.
%     O(h^2) convergence is expected for the midpoint and trapezoidal rules.
%% ---------------------------------------------------------------

figure('Name', 'Error Convergence (log-log)', ...
       'Position', [100, 580, 900, 420]);

loglog(n_values, left_err,  'b-o', 'LineWidth', 2, 'MarkerSize', 8); hold on;
loglog(n_values, right_err, 'r-s', 'LineWidth', 2, 'MarkerSize', 8);
loglog(n_values, mid_err,   'g-^', 'LineWidth', 2, 'MarkerSize', 8);
loglog(n_values, trap_err,  'm-d', 'LineWidth', 2, 'MarkerSize', 8);

% Reference lines to illustrate first- and second-order convergence
h_ref = (b - a) ./ n_values;
loglog(n_values, 0.5  * h_ref,    'k--', 'LineWidth', 1.2);
loglog(n_values, 0.08 * h_ref.^2, 'k:',  'LineWidth', 1.2);

grid on;
xlabel('Number of subintervals  n',           'FontSize', 12);
ylabel('Absolute error  |I_{num} - I_{exact}|', 'FontSize', 12);
title('Error Convergence Comparison (log-log scale)', 'FontSize', 13);
legend('Left-Endpoint', 'Right-Endpoint', 'Midpoint', 'Trapezoidal', ...
       'O(h) reference', 'O(h^{2}) reference', ...
       'Location', 'southwest', 'FontSize', 10);

%% ---------------------------------------------------------------
%  6. FIGURE 3 — Convergence to Exact Value
%     Shows how each method approaches the analytical result
%     as n increases.
%% ---------------------------------------------------------------

figure('Name', 'Convergence to Exact Value', ...
       'Position', [1060, 100, 720, 420]);

plot(n_values, left_res,  'b-o', 'LineWidth', 2, 'MarkerSize', 8); hold on;
plot(n_values, right_res, 'r-s', 'LineWidth', 2, 'MarkerSize', 8);
plot(n_values, mid_res,   'g-^', 'LineWidth', 2, 'MarkerSize', 8);
plot(n_values, trap_res,  'm-d', 'LineWidth', 2, 'MarkerSize', 8);
yline(exact, 'k--', 'LineWidth', 2);

grid on;
set(gca, 'XScale', 'log');
xlabel('Number of subintervals  n', 'FontSize', 12);
ylabel('Integral approximation',    'FontSize', 12);
title('Convergence of Numerical Methods to the Exact Value', 'FontSize', 13);
legend('Left-Endpoint', 'Right-Endpoint', 'Midpoint', 'Trapezoidal', ...
       sprintf('Exact = %.6f', exact), ...
       'Location', 'east', 'FontSize', 10);

%% ---------------------------------------------------------------
%  SUMMARY
%% ---------------------------------------------------------------

fprintf('=== SUMMARY ===\n');
fprintf('The Midpoint and Trapezoidal rules converge at O(h^2),\n');
fprintf('while the Left- and Right-Endpoint rules converge at O(h).\n');
fprintf('Consequently, the second-order methods achieve significantly\n');
fprintf('smaller errors for the same number of subintervals.\n\n');

%% ==============================================================
%%  LOCAL FUNCTIONS
%%  Each method is implemented as an independent function,
%%  following the same loop-based structure used in the course
%%  (analogous to the simpson_13 function shown in lectures).
%% ==============================================================

function result = left_endpoint(f, a, b, N)
% LEFT-ENDPOINT RECTANGLE RULE
%
%   Approximates the definite integral of f over [a, b] using N
%   subintervals. Each subinterval contributes a rectangle whose
%   height equals the function value at its LEFT edge:
%
%       I ≈ h * sum( f(x_i) ),   i = 0, 1, ..., N-1
%
%   Convergence order: O(h),  h = (b-a)/N

    x      = linspace(a, b, N + 1);   % N+1 equally spaced nodes
    h      = x(2) - x(1);             % uniform step size
    result = 0;

    for ii = 1 : N
        x_left = x(ii);               % left edge of the i-th subinterval
        result = result + h * f(x_left);
    end
end

% ---------------------------------------------------------------

function result = right_endpoint(f, a, b, N)
% RIGHT-ENDPOINT RECTANGLE RULE
%
%   Same as the left-endpoint rule, but the rectangle height is
%   evaluated at the RIGHT edge of each subinterval:
%
%       I ≈ h * sum( f(x_{i+1}) ),   i = 0, 1, ..., N-1
%
%   Convergence order: O(h)

    x      = linspace(a, b, N + 1);
    h      = x(2) - x(1);
    result = 0;

    for ii = 1 : N
        x_right = x(ii + 1);          % right edge of the i-th subinterval
        result  = result + h * f(x_right);
    end
end

% ---------------------------------------------------------------

function result = midpoint_rule(f, a, b, N)
% MIDPOINT RECTANGLE RULE
%
%   The rectangle height is evaluated at the MIDPOINT of each
%   subinterval, which cancels the leading error term and yields
%   second-order accuracy:
%
%       I ≈ h * sum( f( (x_i + x_{i+1}) / 2 ) ),   i = 0, ..., N-1
%
%   Convergence order: O(h^2)

    x      = linspace(a, b, N + 1);
    h      = x(2) - x(1);
    result = 0;

    for ii = 1 : N
        x_mid  = (x(ii) + x(ii + 1)) / 2;   % midpoint of the subinterval
        result = result + h * f(x_mid);
    end
end

% ---------------------------------------------------------------

function result = trapezoidal(f, a, b, N)
% TRAPEZOIDAL RULE
%
%   Approximates the integral by summing the areas of trapezoids
%   formed between consecutive nodes:
%
%       I ≈ (h/2) * [ f(x_0) + 2f(x_1) + ... + 2f(x_{N-1}) + f(x_N) ]
%
%   Equivalently, per subinterval:
%       I ≈ sum( (h/2) * (f(x_i) + f(x_{i+1})) ),   i = 0, ..., N-1
%
%   Convergence order: O(h^2)

    x      = linspace(a, b, N + 1);
    h      = x(2) - x(1);
    result = 0;

    for ii = 1 : N
        x0     = x(ii);
        x1     = x(ii + 1);
        result = result + (h / 2) * (f(x0) + f(x1));   % trapezoid area
    end
end
