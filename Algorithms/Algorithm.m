classdef Algorithm < handle

    properties
        name
        pop_size
        iter_num
        eva_num
    end

    methods

        function obj = Algorithm(name)
            obj.name = name;
        end

        function obj = setPreRun(obj, pre_run_list)
            obj.pop_size = pre_run_list(1);
            obj.iter_num = pre_run_list(2);
            obj.eva_num = pre_run_list(3);
        end

        function name = getName(obj)
            name = obj.name;
        end

        function setName(obj, name)
            obj.name = name;
        end

        function parameter = getParameter(obj)

        end

        function obj = setParameter(obj, parameter_cell)

        end

        function data = run(obj, Tasks)

        end

    end

end
