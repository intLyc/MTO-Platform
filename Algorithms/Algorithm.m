classdef Algorithm < handle

    properties
        name % algorithm's name
        pop_size % population size
        iter_num % num of max iteration
        eva_num % num of max evaluation
    end

    methods

        function obj = Algorithm(name)
            % algorithm constructor
            % cannot be changed

            obj.name = name;
        end

        function obj = setPreRun(obj, pre_run_list)
            % set pre run parameter pre_run_list [pop_size, iter_num, eva_num]
            % cannot be changed

            obj.pop_size = pre_run_list(1);
            obj.iter_num = pre_run_list(2);
            obj.eva_num = pre_run_list(3);
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
