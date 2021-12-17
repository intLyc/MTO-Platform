classdef Algorithm < handle

    properties
        name % algorithm's name
    end

    methods

        function obj = Algorithm(name)
            % algorithm constructor
            % cannot be changed

            obj.name = name;
        end

        function name = getName(obj)
            % get algorithm's name
            % cannot be changed

            name = obj.name;
        end

        function setName(obj, name)
            % set algorithm's name
            % cannot be changed

            obj.name = name;
        end

    end

    methods (Abstract)

        getParameter(obj) % get algorithm's parameter
        % return parameter, contains {para1, value1, para2, value2, ...} (string)

        setParameter(obj, parameter_cell) % set algorithm's parameter
        % arg parameter_cell, contains {value1, value2, ...} (string)

        run(obj, Tasks) % run this tasks with algorithm,
        % return data, contains data.clock_time, data.convergence

    end

end
