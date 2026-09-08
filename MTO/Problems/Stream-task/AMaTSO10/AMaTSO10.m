classdef AMaTSO10 < Problem
% <Stream-task> <Single-objective> <None>
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
% Task definitions match case 10 of the author AMTO benchmark_CEC17_MTSO.

properties
    Seed = 123
    Arrival
    TaskBudget
end

methods
    function Prob = AMaTSO10(varargin)
        Prob = Prob@Problem(varargin{:});
    end

    function p = getParameter(Prob)
        p = [Prob.getRunParameter(), {'Arrival seed', num2str(Prob.Seed)}];
    end

    function Prob = setParameter(Prob, p)
        Prob.N = str2double(p{1}); Prob.maxFE = str2double(p{2});
        Prob.Seed = str2double(p{3}); Prob.setTasks();
    end

    function setTasks(Prob)
        if isempty(Prob.maxFE), Prob.maxFE = 1000000; end
        Prob.T = 10; Prob.M = 1;
        Prob.D = [50, 50, 50, 25, 50, 50, 50, 50, 50, 50];
        functions = {@Sphere, @Sphere, @Sphere, @Weierstrass, @Rosenbrock, ...
                @Ackley, @Weierstrass, @Schwefel, @Griewank, @Rastrigin};
        bounds = [100, 100, 100, 0.5, 50, 50, 0.5, 500, 100, 50];
        % Task 5 uses zero-shift Rosenbrock, whose optimum is the all-ones vector.
        shifts = {0, 80, -80, -0.4, 0, 40, -0.4, 0, ...
                [-80 * ones(1, 25), 80 * ones(1, 25)], ...
                [40 * ones(1, 25), -40 * ones(1, 25)]};
        for t = 1:Prob.T
            fn = functions{t}; shift = shifts{t};
            Prob.Fnc{t} = @(x) fn(x, 1, shift, 0);
            Prob.Lb{t} = -bounds(t) * ones(1, Prob.D(t));
            Prob.Ub{t} = bounds(t) * ones(1, Prob.D(t));
        end
        % Split total FE equally; Arrival uses the shared clock and TaskBudget uses local task FE.
        Prob.TaskBudget = repmat(Prob.maxFE / Prob.T, 1, Prob.T);
        Prob.Arrival = KR_AMTEA_Arrivals(Prob.T, Prob.maxFE, Prob.Seed);
    end
end
end
