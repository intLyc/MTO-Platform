function Task = benchmark_CEC10_CSO(index, dim)

%------------------------------- Reference --------------------------------
% @Article{Mallipeddi2010CEC10-CSO,
%   title    = {Problem Definitions and Evaluation Criteria for the Cec 2010 Competition on Constrained Real-parameter Optimization},
%   author   = {Mallipeddi, Rammohan and Suganthan, Ponnuthurai},
%   year     = {2010},
%   month    = {05},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

% Boundary Constraint
lb = [0, -5.12, -1000, -50, -600, -600, -140, -140, -500, -500, ...
    -100, -1000, -500, -1000, -1000, -10, -10, -50];
ub = [10, 5.12, 1000, 50, 600, 600, 140, 140, 500, 500, ...
        100, 1000, 500, 1000, 1000, 10, 10, 50];

%% Set Task
Task.Dim = dim; % dimensionality of Task 1
Task.Fnc = @(x)CEC10_CSO_Func(x, index);
Task.Lb = lb(index) * ones(1, dim); % Upper bound of Task 1
Task.Ub = ub(index) * ones(1, dim); % Lower bound of Task 1
end
