classdef WCCI2020_MTSO3 < Problem

    properties
    end

    methods
        function parameter = getParameter(obj)
            parameter = {};
        end

        function obj = setParameter(obj, parameter_cell)
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_WCCI2020_MTSO(3);
        end

    end

end
