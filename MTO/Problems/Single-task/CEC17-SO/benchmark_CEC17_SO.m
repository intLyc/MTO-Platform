function Tasks = benchmark_CEC17_SO(index, dim)

%------------------------------- Reference --------------------------------
% @Article{Awad2017CEC17-SO,
%   author     = {N. H. Awad and M. Z. Ali and J. J. Liang and B. Y. Qu and P. N. Suganthan},
%   journal    = {Technical Report, Nanyang Technological University, Singapore},
%   title      = {Problem Definitions and Evaluation Criteria for the CEC 2017 Special Session and Competition on Single Objective Bound Constrained Real-Parameter Numerical Optimization},
%   year       = {2017},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

g = (1:30) * 100;
if index >= 2
    index = index + 1; % F2 has been deleted
end

Tasks.Dim = dim;
Tasks.Lb = -100 * ones(1, dim);
Tasks.Ub = 100 * ones(1, dim);
Tasks.Fnc = @(x)get_func(x, index, g(index));
end

function [Obj, Con] = get_func(x, index, g)
Obj = cec17_func(x', index) - g;
Obj = Obj';
Con = zeros(size(x, 1), 1);
end
