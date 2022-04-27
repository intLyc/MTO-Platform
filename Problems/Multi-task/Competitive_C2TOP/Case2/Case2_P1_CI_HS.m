classdef Case2_P1_CI_HS < Problem
    % <Multi> <Competitive>

    methods
        function obj = Case2_P1_CI_HS(name)
            obj = obj@Problem(name);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(1, 2);
        end
    end
end
