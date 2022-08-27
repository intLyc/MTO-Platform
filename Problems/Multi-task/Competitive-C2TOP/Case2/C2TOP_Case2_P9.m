classdef C2TOP_Case2_P9 < Problem
    % <Multi> <Competitive>

    methods
        function obj = C2TOP_Case2_P9(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(9, 2);
        end
    end
end
