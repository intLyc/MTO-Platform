classdef Case4_P4_PI_HS < Problem
    % <Multi> <Competitive>

    methods
        function obj = Case4_P4_PI_HS(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(4, 4);
        end
    end
end
