classdef CMT7 < Problem
    % <Multi-task> <Single-objective> <Constrained>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Li2022CMT-Benchmark,
    %   title     = {Evolutionary Constrained Multi-Task Optimization: Benchmark Problems and Preliminary Results},
    %   author    = {Li, Yanchi and Gong, Wenyin and Li, Shuijia},
    %   booktitle = {Proceedings of the Genetic and Evolutionary Computation Conference Companion},
    %   year      = {2022},
    %   pages     = {443–446},
    %   publisher = {Association for Computing Machinery},
    %   series    = {GECCO '22},
    %   doi       = {10.1145/3520304.3528890},
    %   numpages  = {4},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function Prob = CMT7(varargin)
            Prob = Prob@Problem(varargin);
            Prob.maxFE = 1000 * mean(Prob.D) * Prob.T;
        end

        function Parameter = getParameter(Prob)
            Parameter = {'Dim', num2str(mean(Prob.D))};
            Parameter = [Prob.getRunParameter(), Parameter];
        end

        function Prob = setParameter(Prob, Parameter)
            D = str2double(Parameter{3});
            if mean(Prob.D) == D
                Prob.setRunParameter(Parameter(1:2));
            else
                Prob.D = ones(1, Prob.T) * D;
                Prob.maxFE = 1000 * mean(Prob.D) * Prob.T;
                Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
            end
        end

        function setTasks(Prob)
            Prob.T = 2;
            if isempty(Prob.D)
                Prob.D = ones(1, Prob.T) * Prob.defaultD;
            end

            Prob.Fnc{1} = @(x)Rosenbrock1(x, 1, -30 * ones(1, Prob.D(1)), -35 * ones(1, Prob.D(1)));
            Prob.Lb{1} = -50 * ones(1, Prob.D(1));
            Prob.Ub{1} = 50 * ones(1, Prob.D(1));

            Prob.Fnc{2} = @(x)Rastrigin1(x, 1, 35 * ones(1, Prob.D(2)), 40 * ones(1, Prob.D(2)));
            Prob.Lb{2} = -50 * ones(1, Prob.D(2));
            Prob.Ub{2} = 50 * ones(1, Prob.D(2));
        end
    end
end
