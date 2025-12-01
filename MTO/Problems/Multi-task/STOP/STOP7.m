classdef STOP7 < Problem
% <Many-task> <Single-objective> <None>

%% Original:
%------------------------------- Reference --------------------------------
% @Article{Xue2023STOP-G,
%   title      = {A Scalable Test Problem Generator for Sequential Transfer Optimization},
%   author     = {Xue, Xiaoming and Yang, Cuie and Feng, Liang and Zhang, Kai and Song, Linqi and Tan, Kay Chen},
%   journal    = {IEEE Transactions on Cybernetics},
%   year       = {2025},
%   number     = {5},
%   pages      = {2110-2123},
%   volume     = {55},
%   doi        = {10.1109/TCYB.2025.3547565},
% }
%--------------------------------------------------------------------------
%% Modified by:
%------------------------------- Reference --------------------------------
% @Article{Zhang2025DTSKT,
%   title      = {Distribution Direction-Assisted Two-Stage Knowledge Transfer for Many-Task Optimization},
%   author     = {Zhang, Tingyu and Wu, Xinyi and Li, Yanchi and Gong, Wenyin and Qin, Hu},
%   journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
%   year       = {2025},
%   pages      = {1-15},
%   doi        = {10.1109/TSMC.2025.3598800},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------
methods
    function Prob = STOP7(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 1000 * 50 * Prob.T;
    end

    function Parameter = getParameter(Prob)
        Parameter = {'Task Num', num2str(Prob.T)};
        Parameter = [Prob.getRunParameter(), Parameter];
    end

    function Prob = setParameter(Prob, Parameter)
        T = str2double(Parameter{3});
        if Prob.T == T
            Prob.setRunParameter(Parameter(1:2));
        else
            Prob.T = T;
            Prob.maxFE = 1000 * 50 * Prob.T;
            Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
        end
    end

    function setTasks(Prob)
        if ~isempty(Prob.T)
            T = Prob.T;
        else
            T = Prob.defaultT;
            Prob.T = Prob.defaultT;
        end
        Tasks = benchmark_STOP(7, T);
        Prob.D = [];
        Prob.Fnc = {};
        Prob.Lb = {};
        Prob.Ub = {};
        for t = 1:Prob.T
            Prob.D(t) = Tasks(t).Dim;
            Prob.Fnc{t} = Tasks(t).Fnc;
            Prob.Lb{t} = Tasks(t).Lb;
            Prob.Ub{t} = Tasks(t).Ub;
        end
    end
end
end
