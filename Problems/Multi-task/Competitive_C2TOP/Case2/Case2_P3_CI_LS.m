classdef Case2_P3_CI_LS < Problem
    % <Multi> <Competitive>

    methods
        function obj = Case2_P3_CI_LS(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(3, 2);
        end
    end
end
