classdef Case1_P1_CI_HS < Problem
    % <Multi> <Competitive>

    methods
        function obj = Case1_P1_CI_HS(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(1, 1);
        end
    end
end
