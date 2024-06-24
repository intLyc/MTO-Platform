function Tasks = benchmark_CEC22_SO(index, dim)

%------------------------------- Reference --------------------------------
% @Article{Kumar2022CEC22-SO,
%   title      = {Problem Definitions and Evaluation Criteria for the CEC 2022 Special Session and Competition on Single Objective Bound Constrained Numerical Optimization},
%   author     = {Abhishek Kumar and Kenneth V. Price and Ali Wagdy Mohamed and Anas A. Hadi and P. N.Suganthan},
%   year       = {2022},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------
% Global optima
g = [300, ... % Unimodal Function 1
        400, 600, 800, 900, ... % Basic Functions 2,3,4,5
        1800, 2000, 2200, ... % Hybrid Functions 6,7,8
        2300, 2400, 2600, 2700]; % Composition Functions 9,10,11,12

Tasks.Dim = dim;
Tasks.Lb = -100 * ones(1, dim);
Tasks.Ub = 100 * ones(1, dim);
Tasks.Fnc = @(x)get_func(x, index, g(index));
end

function [Obj, Con] = get_func(x, index, g)
Obj = cec22_test_func(x', index) - g;
Obj = Obj';
Con = zeros(size(x, 1), 1);
end
