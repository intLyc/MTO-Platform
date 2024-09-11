classdef LSMaTSO2 < Problem
% <Many-task> <Single-objective> <None>

%------------------------------- Reference --------------------------------
% @Article{Li2024TNG-NES,
%   title   = {Transfer Task-averaged Natural Gradient for Efficient Many-task Optimization},
%   author  = {Li, Yanchi and Gong, Wenyin and Gu, Qiong},
%   journal = {IEEE Transactions on Evolutionary Computation},
%   year    = {2024},
%   doi     = {10.1109/TEVC.2024.3459862},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = LSMaTSO2(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 500 * mean(Prob.D) * Prob.T;
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
            Prob.maxFE = 500 * mean(Prob.D) * Prob.T;
            Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
        end
    end

    function setTasks(Prob)
        if ~isempty(Prob.T)
            T = Prob.T;
        else
            T = Prob.defaultT;
            Prob.T = T;
        end
        Tasks = benchmark_LSMaTSO(2, T);
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
