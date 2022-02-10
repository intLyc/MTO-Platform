classdef Case3_P7_NI_HS < Problem

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
            Tasks = benchmark_CEC17_MTSO_Competitive(7, 3);
        end
    end
end
