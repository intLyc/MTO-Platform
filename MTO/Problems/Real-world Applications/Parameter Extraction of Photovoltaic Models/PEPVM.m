classdef PEPVM < Problem
% <Multi-task> <Single-objective> <None/Competitive>

% Parameter Extraction of Photovoltaic Models

%------------------------------- Reference --------------------------------
% Reference 1
% @Article{Li2020Enhanced,
%   title      = {An Enhanced Adaptive Differential Evolution Algorithm for Parameter Extraction of Photovoltaic Models},
%   author     = {Shuijia Li and Qiong Gu and Wenyin Gong and Bin Ning},
%   journal    = {Energy Conversion and Management},
%   year       = {2020},
%   issn       = {0196-8904},
%   pages      = {112443},
%   volume     = {205},
%   doi        = {https://doi.org/10.1016/j.enconman.2019.112443},
% }
% Reference 2
% @Article{Li2022MTEA-SaO,
%   title      = {Multitasking Optimization via an Adaptive Solver Multitasking Evolutionary Framework},
%   author     = {Yanchi Li and Wenyin Gong and Shuijia Li},
%   journal    = {Information Sciences},
%   year       = {2022},
%   issn       = {0020-0255},
%   doi        = {https://doi.org/10.1016/j.ins.2022.10.099},
% }
% Reference 3
% @Article{Li2023MTSRA,
%   author     = {Yanchi Li and Wenyin Gong and Shuijia Li},
%   journal    = {Expert Systems with Applications},
%   title      = {Evolutionary Competitive Multitasking Optimization via Improved Adaptive Differential Evolution},
%   year       = {2023},
%   issn       = {0957-4174},
%   pages      = {119550},
%   doi        = {https://doi.org/10.1016/j.eswa.2023.119550},
% }
%--------------------------------------------------------------------------

methods
    function Prob = PEPVM(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 1000 * 300;
    end

    function parameter = getParameter(Prob)
        parameter = Prob.getRunParameter();
    end

    function Prob = setParameter(Prob, parameter_cell)
        Prob.setRunParameter(parameter_cell);
    end

    function setTasks(Prob)
        Prob.T = 3;
        Prob.M(1) = 1;
        Prob.D(1) = 5;
        Prob.Fnc{1} = @(x)SingleModel(x);
        Prob.Lb{1} = [0, 0, 0, 0, 1];
        Prob.Ub{1} = [1, 1e-6, 0.5, 100, 2];

        Prob.M(2) = 1;
        Prob.D(2) = 7;
        Prob.Fnc{2} = @(x)DoubleModel(x);
        Prob.Lb{2} = [0, 0, 0, 0, 1, 0, 1];
        Prob.Ub{2} = [1, 1e-6, 0.5, 100, 2, 1e-6, 2];

        Prob.M(3) = 1;
        Prob.D(3) = 5;
        Prob.Fnc{3} = @(x)PVModel(x);
        Prob.Lb{3} = [0, 0, 0, 0, 1];
        Prob.Ub{3} = [2, 5e-5, 2, 2000, 50];
    end
end
end

function [Obj, Con] = SingleModel(x)
q = 1.60217646e-19;
k = 1.3806503e-23;
summ = 0;

T = 273.15 + 33.0;

V_t = k * T / q;

I_ph = x(:, 1);
I_sd = x(:, 2);
R_s = x(:, 3);
R_sh = x(:, 4);
a = x(:, 5);

V_L = [-0.2057, -0.1291, -0.0588, 0.0057, 0.0646, 0.1185, 0.1678, 0.2132, 0.2545, 0.2924, 0.3269, 0.3585, 0.3873, 0.4137, 0.4373, 0.4590, 0.4784, 0.4960, ...
        0.5119, 0.5265, 0.5398, 0.5521, 0.5633, 0.5736, 0.5833, 0.5900];
I_L = [0.7640, 0.7620, 0.7605, 0.7605, 0.7600, 0.7590, 0.7570, 0.7570, 0.7555, 0.7540, 0.7505, 0.7465, 0.7385, 0.7280, 0.7065, 0.6755, ...
        0.6320, 0.5730, 0.4990, 0.4130, 0.3165, 0.2120, 0.1035, -0.0100, -0.1230, -0.2100];
row = 26;
for i = 1:row
    y1 = I_ph - I_sd .* (exp((V_L(i) + I_L(i) .* R_s) ./ (a .* V_t)) - 1) - (V_L(i) + I_L(i) .* R_s) ./ R_sh - I_L(i);
    summ = summ + y1 .* y1;
end

Obj = sqrt(summ ./ row);
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = DoubleModel(x)
summ = 0;
q = 1.60217646e-19;
k = 1.3806503e-23;
T = 273.15 + 33.0;

V_t = k * T / q;

I_ph = x(:, 1);
I_sd1 = x(:, 2);
R_s = x(:, 3);
R_sh = x(:, 4);
a1 = x(:, 5);
I_sd2 = x(:, 6);
a2 = x(:, 7);

V_L = [-0.2057, -0.1291, -0.0588, 0.0057, 0.0646, 0.1185, 0.1678, 0.2132, 0.2545, 0.2924, 0.3269, 0.3585, 0.3873, 0.4137, 0.4373, 0.4590, 0.4784, 0.4960, ...
        0.5119, 0.5265, 0.5398, 0.5521, 0.5633, 0.5736, 0.5833, 0.5900];
I_L = [0.7640, 0.7620, 0.7605, 0.7605, 0.7600, 0.7590, 0.7570, 0.7570, 0.7555, 0.7540, 0.7505, 0.7465, 0.7385, 0.7280, 0.7065, 0.6755, ...
        0.6320, 0.5730, 0.4990, 0.4130, 0.3165, 0.2120, 0.1035, -0.0100, -0.1230, -0.2100];
row = 26;

for i = 1:row
    y1 = I_ph - I_sd1 .* (exp((V_L(i) + I_L(i) .* R_s) ./ (a1 .* V_t)) - 1) - I_sd2 .* (exp((V_L(i) + I_L(i) .* R_s) ./ (a2 .* V_t)) - 1) - (V_L(i) + I_L(i) .* R_s) ./ R_sh - I_L(i);
    summ = summ + y1 .* y1;
end

Obj = sqrt(summ ./ row);
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = PVModel(x)
q = 1.60217646e-19;
k = 1.3806503e-23;
summ = 0;

T = 273.15 + 45.0;

V_t = k * T / q;

I_ph = x(:, 1);
I_sd = x(:, 2);
R_s = x(:, 3);
R_sh = x(:, 4);
a = x(:, 5);
Ns = 1;

V_L = [0.1248, 1.8093, 3.3511, 4.7622, 6.0538, 7.2364, 8.3189, 9.3097, 10.2163, 11.0449, 11.8018, 12.4929, 13.1231, 13.6983, 14.2221, 14.6995, 15.1346, 15.5311, ...
        15.8929, 16.2229, 16.5241, 16.7987, 17.0499, 17.2793, 17.4885];
I_L = [1.0315, 1.0300, 1.0260, 1.0220, 1.0180, 1.0155, 1.0140, 1.0100, 1.0035, 0.9880, 0.9630, 0.9255, 0.8725, 0.8075, 0.7265, 0.6345, ...
        0.5345, 0.4275, 0.3185, 0.2085, 0.1010, -0.0080, -0.1110, -0.2090, -0.3030];
row = 25;
for i = 1:row
    y1 = I_ph - I_sd .* (exp((V_L(i) + I_L(i) .* R_s) ./ (a .* Ns .* V_t)) - 1) - (V_L(i) + I_L(i) .* R_s) ./ R_sh - I_L(i);
    summ = summ + y1 .* y1;
end

Obj = sqrt(summ ./ row);
Con = zeros(size(x, 1), 1);
end
