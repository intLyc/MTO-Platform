classdef Case1_P9_NI_LS < Problem
    % <Multi> <Competitive>

    methods
        function obj = Case1_P9_NI_LS(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(9, 1);
        end
    end
end
