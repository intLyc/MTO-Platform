classdef Case4_P6_PI_LS < Problem
    % <Multi> <Competitive>

    properties
    end

    methods
        function parameter = getParameter(obj)
            parameter = obj.getRunParameter();
        end

        function obj = setParameter(obj, parameter_cell)
            obj.setRunParameter(parameter_cell(1:3));
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO_Competitive(6, 4);
        end
    end
end
