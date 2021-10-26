classdef Problem < handle

    properties
        name % problem's name
    end

    methods

        function obj = Problem(name)
            % problem constructor
            % cannot be changed

            obj.name = name;
        end

        function name = getName(obj)
            % get problem's name
            % cannot be changed

            name = obj.name;
        end

        function obj = setName(obj, name)
            % set problem's name
            % cannot be changed

            obj.name = name;
        end

    end

    methods (Abstract)

        getParameter(obj) % get problem's parameter
        % return parameter, contains {para1, value1, para2, value2, ...} (string)

        setParameter(obj, parameter_cell) % set problem's parameter
        % arg parameter_cell, contains {value1, value2, ...} (string)

        getTasks(obj) % get problem's tasks
        % return tasks, contains [task1, task2, ...]
        % taski in tasks, contains task.dims, task.fnc, task.Lb, task.Ub

    end

end
