classdef AMTSO_Case2_P1 < Problem
% <Multi-task> <Single-objective> <None> <Stream>

%------------------------------- Reference --------------------------------
% @Article{Han2026KR_AMTEA,
%   title      = {Multitense Knowledge Transfer for Asynchronous Multitasking Optimization},
%   author     = {Han, Honggui and Zhao, Ben and Wu, Xiaolong and Li, Xin},
%   journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
%   year       = {2026},
%   volume     = {56},
%   number     = {5},
%   pages      = {3370--3383},
%   doi        = {10.1109/TSMC.2026.3658328},
% }
%--------------------------------------------------------------------------

properties
    Arrival
    TaskBudget
end

methods
    function Prob = AMTSO_Case2_P1(varargin)
        Prob = Prob@Problem(varargin{:});
    end

    function setTasks(Prob)
        if isempty(Prob.maxFE), Prob.maxFE = 200000; end
        % P1 follows the author numbering: T1 / T2 = Griewank / Rastrigin; the benchmark loads transformation data.
        tasks = benchmark_CEC17_MTSO(1);
        Prob.T = 2; Prob.M = 1;
        Prob.D = [tasks.Dim]; Prob.Fnc = {tasks.Fnc};
        Prob.Lb = {tasks.Lb}; Prob.Ub = {tasks.Ub};
        % Split the total maxFE budget equally between the two tasks.
        Prob.TaskBudget = repmat(Prob.maxFE / Prob.T, 1, Prob.T);
        % Case2 adapts the paper's 1000 setting: T2 arrives when T1 exhausts its budget.
        Prob.Arrival = [0, round(1 * Prob.TaskBudget(1))];
    end
end
end
