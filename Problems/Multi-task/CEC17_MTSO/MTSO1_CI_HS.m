classdef MTSO1_CI_HS < Problem
    % <Multi> <None>

    properties
    end

    methods
        function parameter = getParameter(obj)
            parameter = obj.getRunParameter();
        end

        function obj = setParameter(obj, parameter_cell)
            obj.setRunParameter(parameter_cell);
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_CEC17_MTSO(1);
        end
    end
end
