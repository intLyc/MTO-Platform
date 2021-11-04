classdef Problem < handle

    properties
        name % problem's name
        pop_size = 100 % population size
        iter_num = 1000 % num of max iteration
        eva_num = inf % num of max evaluation
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

        function run_parameter = getRunParameter(obj)
            % get run_parameter

            run_parameter = {'Population Size', num2str(obj.pop_size), ...
                        'Iteration Num', num2str(obj.iter_num), ...
                            'Evaluation Num', num2str(obj.eva_num)};
        end

        function obj = setRunParameter(obj, run_parameter)
            % set run_parameter

            obj.pop_size = str2num(run_parameter{1});
            obj.iter_num = str2num(run_parameter{2});
            obj.eva_num = str2num(run_parameter{3});
        end

        function run_parameter_list = getRunParameterList(obj)
            run_parameter_list = [obj.pop_size, obj.iter_num, obj.eva_num];
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
