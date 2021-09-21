classdef Problem < handle

    properties
        name
        dims
        tasks_name
    end

    methods

        function obj = Problem(name)
            obj.name = name;
        end

        function obj = setName(obj, name)
            obj.name = name;
        end

        function name = getName(obj, name)
            name = obj.name;
        end

        function num = getTasksNumber(obj)
            num = length(obj.dims);
        end

        function parameter = getParameter(obj)
            parameter = {};

            for i = 1:length(obj.tasks_name)
                parameter = [parameter, [obj.tasks_name{i}, ' dim'], num2str(obj.dims(i))];
            end

        end

        function obj = setParameter(obj, parameter_cell)

            for i = 1:length(obj.dims)
                obj.dims(i) = str2num(parameter_cell{i});
            end

        end

        function Tasks = getTasks(obj)

        end

    end

end
