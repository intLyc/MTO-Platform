classdef Case3_P7_NI_HS < Problem
    % <Multi> <Competitive>

    methods
        function obj = Case3_P7_NI_HS(name)
            obj = obj@Problem(name);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(7, 3);
        end
    end
end
