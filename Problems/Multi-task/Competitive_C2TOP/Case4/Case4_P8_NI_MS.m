classdef Case4_P8_NI_MS < Problem
    % <Multi> <Competitive>

    methods
        function obj = Case4_P8_NI_MS(name)
            obj = obj@Problem(name);
            obj.sub_eva = 1000 * 100;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(8, 4);
        end
    end
end
