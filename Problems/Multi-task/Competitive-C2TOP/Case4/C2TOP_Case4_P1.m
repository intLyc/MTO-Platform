classdef C2TOP_Case4_P1 < Problem
    % <Multi> <Competitive>

    methods
        function obj = C2TOP_Case4_P1(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(1, 4);
        end
    end
end
