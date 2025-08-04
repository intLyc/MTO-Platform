classdef MGA_DSM_GTOP < Problem
% <Multi-task/Many-task> <Single-objective> <None>

%------------------------------- Reference --------------------------------
% @Article{Yuan2025Scenario,
%   author   = {Zhuoming Yuan and Guangming Dai and Lei Peng and Maocai Wang and Zhiming Song and Xiaoyu Chen},
%   journal  = {Knowledge-Based Systems},
%   title    = {Scenario-based self-learning transfer framework for multi-task optimization problems},
%   year     = {2025},
%   issn     = {0950-7051},
%   pages    = {113824},
%   volume   = {325},
%   doi      = {https://doi.org/10.1016/j.knosys.2025.113824},
% }
%---------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

% ------------------------------------------------------------------------
% This source file is part of the 'ESA Advanced Concepts Team's
% Space Mechanics Toolbox' software.
%
% The source files are avaliable in https://www.esa.int/gsp/ACT/projects/gtop/
%
% Copyright (c) 2004-2007 European Space Agency
% ------------------------------------------------------------------------

properties
    Ntask = 5;
    Gen = 500;
end

methods

    function Prob = MGA_DSM_GTOP(name)
        Prob = Prob@Problem(name);
        Prob.maxFE = Prob.Ntask * Prob.N * Prob.Gen;
    end

    function parameter = getParameter(Prob)
        parameter = {'Gen: Generation number', num2str(Prob.Gen), };
        parent_para = Prob.getRunParameter();
        parameter = [parent_para, parameter];
    end

    function Prob = setParameter(Prob, Parameter)
        Prob.Gen = str2double(Parameter{3});
        Prob.T = Prob.Ntask;
        if Prob.maxFE ~= Prob.Ntask * Prob.N * Prob.Gen
            Prob.maxFE = Prob.Ntask * Prob.N * Prob.Gen;
            Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
        else
            Prob.setRunParameter({Parameter{1}, Parameter{2}});
        end
    end

    function setTasks(Prob)
        Prob.maxFE = Prob.Ntask * Prob.N * Prob.Gen;
        Prob.T = Prob.Ntask;
        Prob.D = [];
        Prob.Lb = {};
        Prob.Ub = {};
        Prob.Fnc = {};
        for t = 1:Prob.T
            if t == 1
                [~, lb, ub, D, fn, ~] = dataload(2);
                Prob.D(t) = D;
                Prob.Lb{t} = lb;
                Prob.Ub{t} = ub;
                Prob.Fnc{t} = fn;
            elseif t == 2
                [~, lb, ub, D, fn, ~] = dataload(4);
                Prob.D(t) = D;
                Prob.Lb{t} = lb;
                Prob.Ub{t} = ub;
                Prob.Fnc{t} = fn;
            elseif t == 3
                [~, lb, ub, D, fn, ~] = dataload(5);
                Prob.D(t) = D;
                Prob.Lb{t} = lb;
                Prob.Ub{t} = ub;
                Prob.Fnc{t} = fn;
            elseif t == 4
                [~, lb, ub, D, fn, ~] = dataload(6);
                Prob.D(t) = D;
                Prob.Lb{t} = lb;
                Prob.Ub{t} = ub;
                Prob.Fnc{t} = fn;
            elseif t == 5
                [~, lb, ub, D, fn, ~] = dataload(7);
                Prob.D(t) = D;
                Prob.Lb{t} = lb;
                Prob.Ub{t} = ub;
                Prob.Fnc{t} = fn;
            end
        end
    end

end

end
