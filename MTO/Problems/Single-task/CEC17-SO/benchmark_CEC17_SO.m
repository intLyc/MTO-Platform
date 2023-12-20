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
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
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
