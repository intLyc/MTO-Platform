classdef Case2_P8_NI_MS < Problem
    % <Multi> <Competitive>

    methods
        function obj = Case2_P8_NI_MS(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(8, 2);
        end
    end
end
