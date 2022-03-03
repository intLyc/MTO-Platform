classdef Problem < handle
    %% Problem Base Class
    % Inherit the Problem class and implement the abstract functions

    properties
        name % problem's name
        sub_pop = 50 % each task population size
        sub_eva = 50 * 1000 % num of max evaluation for each task
    end

    methods
        function obj = Problem(name)
            % problem constructor, cannot be changed
            obj.name = name;
        end

        function name = getName(obj)
            % get problem's name, cannot be changed
            name = obj.name;
        end

        function obj = setName(obj, name)
            % set problem's name, cannot be changed
            obj.name = name;
        end

        function run_parameter = getRunParameter(obj)
            % get run_parameter, cannot be changed
            run_parameter = {'N: Each Task Population Size', num2str(obj.sub_pop), ...
                        'E: Each Task Evaluation Max', num2str(obj.sub_eva)};
        end

        function run_parameter_list = getRunParameterList(obj)
            % get run_parameter_list, cannot be changed
            run_parameter_list = [obj.sub_pop, obj.sub_eva];
        end

        function obj = setRunParameter(obj, run_parameter)
            % set run_parameter, cannot be changed
            obj.sub_pop = str2double(run_parameter{1});
            obj.sub_eva = str2double(run_parameter{2});
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
