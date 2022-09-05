classdef CMT2 < Problem
    % <Multi> <Constrained>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Li2022CMT-Benchmark,
    %   author    = {Li, Yanchi and Gong, Wenyin and Li, Shuijia},
    %   booktitle = {Proceedings of the Genetic and Evolutionary Computation Conference Companion},
    %   title     = {Evolutionary Constrained Multi-Task Optimization: Benchmark Problems and Preliminary Results},
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
        function obj = CMT2(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 1000 * obj.Dim;
        end

        function Parameter = getParameter(obj)
            Parameter = {'Dim', num2str(obj.Dim)};
            Parameter = [obj.getRunParameter(), Parameter];
        end

        function obj = setParameter(obj, Parameter)
            obj.setRunParameter(Parameter(1:2));
            obj.Dim = str2double(Parameter{3});
        end

        function Tasks = getTasks(obj)
            Tasks(1).Dim = obj.Dim;
            Tasks(1).Fnc = @(x)Ackley2(x, 1, 0 * ones(1, obj.Dim), -4 * ones(1, obj.Dim));
            Tasks(1).Lb = -50 * ones(1, obj.Dim);
            Tasks(1).Ub = 50 * ones(1, obj.Dim);

            Tasks(2).Dim = obj.Dim;
            Tasks(2).Fnc = @(x)Rastrigin2(x, 1, 0 * ones(1, obj.Dim), 4 * ones(1, obj.Dim));
            Tasks(2).Lb = -50 * ones(1, obj.Dim);
            Tasks(2).Ub = 50 * ones(1, obj.Dim);
        end
    end
end
