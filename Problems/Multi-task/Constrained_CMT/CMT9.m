classdef CMT9 < Problem
    % <Multi> <Constrained>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Li2022CMT,
    %   title     = {Evolutionary Constrained Multi-task Optimization: Benchmark Problems and Preliminary Results},
    %   author    = {Yanchi, Li and Wenyin, Gong and Shuijia, Li},
    %   booktitle = {Proceedings of the Genetic and Evolutionary Computation Conference Companion},
    %   year      = {2022},
    %   series    = {GECCO '22},
    %   numpages  = {4},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties
        dims = 50;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'Dims', num2str(obj.dims)};
            parameter = [obj.getRunParameter(), parameter];
        end

        function obj = setParameter(obj, parameter_cell)
            obj.setRunParameter(parameter_cell(1:2));
            count = 3;
            obj.dims = str2double(parameter_cell{count}); count = count + 1;
        end

        function Tasks = getTasks(obj)
            Tasks(1).dims = obj.dims;
            Tasks(1).fnc = @(x)Rastrigin4(x, 1, -10 * ones(1, obj.dims), 0 * ones(1, obj.dims));
            Tasks(1).Lb = -50 * ones(1, obj.dims);
            Tasks(1).Ub = 50 * ones(1, obj.dims);

            Tasks(2).dims = obj.dims;
            Tasks(2).fnc = @(x)Schwefel2(x, 1, 0 * ones(1, obj.dims), 100 * ones(1, obj.dims));
            Tasks(2).Lb = -500 * ones(1, obj.dims);
            Tasks(2).Ub = 500 * ones(1, obj.dims);
        end
    end
end
