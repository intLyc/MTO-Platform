classdef WCCI2020_MTSO10 < Problem

    properties
    end

    methods
        function parameter = getParameter(obj)
            parameter = {};
        end

        function obj = setParameter(obj, parameter_cell)
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_WCCI2020_MTSO(10);
        end

    end

end
