%% ============================================================
%  NUMERICAL ANALYSIS — ASSIGNMENT 2
%  Monte Carlo Integration for Functions with Negative Values
%  Integrating f(x) = cos(x) - 0.1x on [-4, 6]
%
%  Features implemented:
%    1) Bounding box evaluation for positive and negative areas.
%    2) Scatter plot visualization for N = 100, 1000, 10000.
%    3) Log-log error convergence analysis across 3 simulations.
%
%  Author : Aydan Aydemir
%  Date   : May 2026
%% ============================================================

clc; clear; close all;

%% ---------------------------------------------------------------
%  1. FUNCTION DEFINITION AND ANALYTICAL INTEGRAL
%% ---------------------------------------------------------------

% Integrand: f(x) = cos(x) - 0.1x
int_f = @(x) cos(x) - 0.1.*x;

% Integration limits and bounding box height
a = -4;   % lower bound
b = 6;    % upper bound
c = 1.5;  % bounding rectangle height (y-axis limits: -c to c)

% Antiderivative: F(x) = sin(x) - 0.05x^2  (obtained analytically)
% Exact value: integral from -4 to 6 of f(x) dx = F(6) - F(-4)
F       = @(x) sin(x) - 0.05.*x.^2;
exact   = F(b) - F(a);

fprintf('================================================\n');
fprintf('  EXACT (ANALYTICAL) INTEGRAL VALUE: %.6f\n', exact);
fprintf('================================================\n\n');

%% ---------------------------------------------------------------
%  2. NUMERICAL COMPUTATION FOR EACH n VALUE
%% ---------------------------------------------------------------

n_values  = [100, 1000, 10000, 100000, 1000000, 10000000, 100000000];
num_cases = length(n_values);

% Pre-allocate result arrays for 3 different simulations
sim_res = zeros(3, num_cases);

% Print results table header
fprintf('%-10s  %-14s  %-14s  %-14s\n', ...
    'N Points', 'Simulation 1', 'Simulation 2', 'Simulation 3');
fprintf('%s\n', repmat('-', 1, 58));

for k = 1:num_cases
    N = n_values(k);
    
    % Run 3 separate simulations for statistical variance
    for sim = 1:3
        sim_res(sim, k) = mont_int_m(a, b, c, N);
    end
    
    fprintf('%-10d  %-14.6f  %-14.6f  %-14.6f\n', ...
        N, sim_res(1, k), sim_res(2, k), sim_res(3, k));
end

%% ---------------------------------------------------------------
%  3. RELATIVE ERROR COMPUTATION
%% ---------------------------------------------------------------

% Calculate relative error for each simulation
rel_err = zeros(3, num_cases);
for sim = 1:3
    rel_err(sim, :) = abs(sim_res(sim, :) - exact) / abs(exact);
end

fprintf('\n');
fprintf('%-10s  %-14s  %-14s  %-14s\n', ...
    'N Points', 'Sim 1 Error', 'Sim 2 Error', 'Sim 3 Error');
fprintf('%s\n', repmat('-', 1, 58));

for k = 1:num_cases
    fprintf('%-10d  %-14.2e  %-14.2e  %-14.2e\n', ...
        n_values(k), rel_err(1, k), rel_err(2, k), rel_err(3, k));
end
fprintf('\n');

%% ---------------------------------------------------------------
%  4. FIGURES 1, 2, 3 — Point Distribution Visualisation
%     Visualizes the bounding box, positive/negative area points,
%     and points falling outside the integral area for specific N.
%% ---------------------------------------------------------------

n_plots = [100, 1000, 10000];

for i = 1:length(n_plots)
    N_curr = n_plots(i);
    figure('Name', sprintf('Monte Carlo Distribution (N = %d)', N_curr), ...
           'Position', [50 + (i-1)*50, 100 + (i-1)*50, 700, 500]);
           
    % Fetch coordinates for the current N value
    [res_val, rx, ry, gx, gy, bx, by] = mont_int_m_coords(a, b, c, N_curr);
    
    hold on; grid on;
    
    % Dynamic marker size to prevent overcrowding in the plot
    if N_curr == 100
        ms = 5;
    elseif N_curr == 1000
        ms = 3;
    else
        ms = 1;
    end
    
    plot(bx, by, 'bx', 'MarkerSize', ms); % Outside points
    plot(rx, ry, 'rx', 'MarkerSize', ms); % Positive area points
    plot(gx, gy, 'gx', 'MarkerSize', ms); % Negative area points
    
    % Plot the actual function curve
    x_fine = linspace(a, b, 500);
    plot(x_fine, int_f(x_fine), 'k-', 'LineWidth', 2);
    plot([a b], [0 0], 'k--'); % x-axis reference
    
    xlim([a-0.5, b+0.5]); ylim([-c-0.2, c+0.2]);
    xlabel('x', 'FontSize', 11);
    ylabel('y', 'FontSize', 11);
    title(sprintf('Monte Carlo Point Distribution (N = %d), Result = %.4f', N_curr, res_val), 'FontSize', 11);
    legend('Outside points', 'Positive area', 'Negative area', 'f(x)', ...
           'Location', 'best', 'FontSize', 10);
end

%% ---------------------------------------------------------------
%  5. FIGURE 4 — Relative Error Convergence (log-log)
%     Expectation: Error decreases proportionally to 1/sqrt(N).
%% ---------------------------------------------------------------

figure('Name', 'Relative Error Analysis', ...
       'Position', [850, 100, 700, 500]);

hold on; grid on; box on;
colors = {'k-o', 'r-o', 'y-o'};
sim_names = {'Simulation 1', 'Simulation 2', 'Simulation 3'};

for sim = 1:3
    loglog(n_values, rel_err(sim, :), colors{sim}, ...
        'LineWidth', 1.5, 'MarkerSize', 5, 'MarkerFaceColor', colors{sim}(1));
end

set(gca, 'XScale', 'log', 'YScale', 'log');
set(gca, 'XTick', [1e2, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8]);

xlabel('Number of Points (N)', 'FontSize', 12);
ylabel('log_{10} (Relative Error)', 'FontSize', 12);
title('Relative Error Convergence (log-log scale)', 'FontSize', 13, 'FontWeight', 'bold');
legend(sim_names, 'Location', 'northeast', 'FontSize', 10);

%% ---------------------------------------------------------------
%  SUMMARY
%% ---------------------------------------------------------------

fprintf('=== SUMMARY ===\n');
fprintf('The Monte Carlo method successfully integrates functions with negative values\n');
fprintf('by tracking points in both the positive and negative Cartesian regions.\n');
fprintf('Visualizations for N=100, 1000, and 10000 clearly show the spatial distribution.\n');
fprintf('As N increases logarithmically, the relative error converges towards zero,\n');
fprintf('demonstrating the probabilistic accuracy of the method.\n\n');

%% ==============================================================
%%  LOCAL FUNCTIONS
%% ==============================================================

function result = mont_int_m(a, b, c, N)
% MONTE CARLO INTEGRATION (LIGHTWEIGHT)
%   Calculates the integral without storing large arrays of coordinates
%   to optimize performance for high N values (e.g., N = 100,000,000).

    int_f = @(x) cos(x) - 0.1.*x;
    
    pos_sayi = 0;
    neg_sayi = 0;
    
    for ii = 1:N
        tas_x = a + (b - a) * rand();
        tas_y = -c + 2 * c * rand();
        fx = int_f(tas_x);
        
        if fx >= 0
            if tas_y >= 0 && tas_y <= fx
                pos_sayi = pos_sayi + 1;
            end
        else
            if tas_y <= 0 && tas_y >= fx
                neg_sayi = neg_sayi + 1;
            end
        end
    end
    
    % Net Integral = Area of bounding box * (net point ratio)
    result = ((pos_sayi - neg_sayi) / N) * (b - a) * (2 * c);
end

% ---------------------------------------------------------------

function [result, kirmizi_x, kirmizi_y, yesil_x, yesil_y, mavi_x, mavi_y] = mont_int_m_coords(a, b, c, N)
% MONTE CARLO INTEGRATION (WITH COORDINATES)
%   Same core logic as mont_int_m, but tracks (x,y) coordinates
%   for visualization purposes. Used specifically for generating plots.

    int_f = @(x) cos(x) - 0.1.*x;
    
    kirmizi_x = []; kirmizi_y = [];
    yesil_x   = []; yesil_y   = [];
    mavi_x    = []; mavi_y    = [];
    
    pos_sayi = 0;
    neg_sayi = 0;
    
    for ii = 1:N
        tas_x = a + (b - a) * rand();
        tas_y = -c + 2 * c * rand();
        fx = int_f(tas_x);
        
        if fx >= 0
            if tas_y >= 0 && tas_y <= fx
                pos_sayi = pos_sayi + 1;
                kirmizi_x(end+1) = tas_x;
                kirmizi_y(end+1) = tas_y;
            else
                mavi_x(end+1) = tas_x;
                mavi_y(end+1) = tas_y;
            end
        else
            if tas_y <= 0 && tas_y >= fx
                neg_sayi = neg_sayi + 1;
                yesil_x(end+1) = tas_x;
                yesil_y(end+1) = tas_y;
            else
                mavi_x(end+1) = tas_x;
                mavi_y(end+1) = tas_y;
            end
        end
    end
    
    result = ((pos_sayi - neg_sayi) / N) * (b - a) * (2 * c);
end