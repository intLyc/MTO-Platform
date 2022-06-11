classdef Case1_P2_CI_MS < Problem
    % <Multi> <Competitive>

    methods
        function obj = Case1_P2_CI_MS(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(2, 1);
        end
    end
end
