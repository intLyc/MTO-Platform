classdef CMT6 < Problem
    % <MT-SO> <Constrained>

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
        function obj = CMT6(varargin)
            obj = obj@Problem(varargin);
            obj.maxFE = 1000 * mean(obj.D) * obj.T;
        end

        function Parameter = getParameter(obj)
            Parameter = {'Dim', num2str(mean(obj.D))};
            Parameter = [obj.getRunParameter(), Parameter];
        end

        function obj = setParameter(obj, Parameter)
            D = str2double(Parameter{3});
            if mean(obj.D) == D
                obj.setRunParameter(Parameter(1:2));
            else
                obj.D = ones(1, obj.T) * D;
                obj.maxFE = 1000 * mean(obj.D) * obj.T;
                obj.setRunParameter({Parameter{1}, num2str(obj.maxFE)});
            end
        end

        function setTasks(obj)
            obj.T = 2;
            if isempty(obj.D)
                obj.D = ones(1, obj.T) * obj.defaultD;
            end

            obj.Fnc{1} = @(x)Ackley2(x, 1, 2 * ones(1, obj.D(1)), 0 * ones(1, obj.D(1)));
            obj.Lb{1} = -50 * ones(1, obj.D(1));
            obj.Ub{1} = 50 * ones(1, obj.D(1));

            obj.Fnc{2} = @(x)Weierstrass3(x, 1, 0.1 * ones(1, obj.D(2)), 0 * ones(1, obj.D(2)));
            obj.Lb{2} = -0.5 * ones(1, obj.D(2));
            obj.Ub{2} = 0.5 * ones(1, obj.D(2));
        end
    end
end
