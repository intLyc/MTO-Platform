classdef Case2_P9_NI_LS < Problem
    % <Multi> <Competitive>

    methods
        function obj = Case2_P9_NI_LS(name)
            obj = obj@Problem(name);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(9, 2);
        end
    end
end
