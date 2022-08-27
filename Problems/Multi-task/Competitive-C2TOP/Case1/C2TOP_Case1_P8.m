classdef C2TOP_Case1_P8 < Problem
    % <Multi> <Competitive>

    methods
        function obj = C2TOP_Case1_P8(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(8, 1);
        end
    end
end
