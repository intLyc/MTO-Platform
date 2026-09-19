classdef APKACP_10 < Problem
% <Many-task> <Single-objective> <None> <Stream>
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
% FE-clock adaptation of Eq. (22), with PKACP's centroid task generator.
% Generate the author's k-means task distribution from Seed; no instance files.

properties
    Dim = 20
    Seed = 123
    Arrival
    TaskBudget
    TaskParameters % [angular range factor, total arm length]
end

methods
    function Prob = APKACP_10(varargin)
        Prob = Prob@Problem(varargin{:});
        Prob.N = 20;
    end

    function p = getParameter(Prob)
        p = [Prob.getRunParameter(), {'Arm dimension', num2str(Prob.Dim), 'Instance seed', num2str(Prob.Seed)}];
    end

    function Prob = setParameter(Prob, p)
        Prob.N = str2double(p{1}); Prob.maxFE = str2double(p{2});
        Prob.Dim = str2double(p{3});
        Prob.Seed = str2double(p{4}); Prob.setTasks();
    end

    function setTasks(Prob)
        if isempty(Prob.maxFE), Prob.maxFE = 20000; end
        Prob.T = 10; Prob.M = 1;
        Prob.D = repmat(Prob.Dim, 1, Prob.T);
        % Give each task an equal FE budget and a fixed set of arm parameters.
        Prob.TaskBudget = repmat(Prob.maxFE / Prob.T, 1, Prob.T);
        % Generate reproducible instances from Seed, then restore the platform RNG state.
        previous = rng; cleanup = onCleanup(@() rng(previous)); %#ok<NASGU>
        rng(Prob.Seed, 'twister');
        % Centroid columns control the total angular range and total arm length.
        [~, Prob.TaskParameters] = kmeans(rand(50 * Prob.T, 2), Prob.T);
        Prob.Arrival = KR_AMTEA_Arrivals(Prob.T, Prob.maxFE, Prob.Seed);
        Prob.Fnc = cell(1, Prob.T); Prob.Lb = Prob.Fnc; Prob.Ub = Prob.Fnc;
        for t = 1:Prob.T
            a = Prob.TaskParameters(t, 1); len = Prob.TaskParameters(t, 2);
            Prob.Lb{t} = zeros(1, Prob.Dim); Prob.Ub{t} = ones(1, Prob.Dim);
            Prob.Fnc{t} = @(x) APKACP_Objective(x, a, len);
        end
    end
end

end
