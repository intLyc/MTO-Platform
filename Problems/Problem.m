classdef Problem < handle

    properties
        name % problem's name
        dims % tasks dim list
        tasks_name % tasks name cell
    end

    methods

        function obj = Problem(name)
            % problem constructor
            % should be inherited as obj@Problem(name)
            % and set obj.dims, obj.tasks_name

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

        function num = getTasksNumber(obj)
            % get problem's tasks number
            % cannot be changed

            num = length(obj.dims);
        end

        function parameter = getParameter(obj)
            % get problem's parameter {task1 name, task1 dim, ...}
            % cannot be changed

            parameter = {};

            for i = 1:length(obj.tasks_name)
                parameter = [parameter, [obj.tasks_name{i}, ' dim'], num2str(obj.dims(i))];
            end

        end

        function obj = setParameter(obj, parameter_cell)
            % set problem's parameter {task1 dim, ...}
            % cannot be changed

            for i = 1:length(obj.dims)
                obj.dims(i) = str2num(parameter_cell{i});
            end

        end

    end

    methods (Abstract)

        getTasks(obj) % get problem's tasks
        % return tasks, contains [task1, task2, ...]
        % taski in tasks, contains task.dims, task.fnc, task.Lb, task.Ub

    end

end
