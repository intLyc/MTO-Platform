classdef Problem < handle
    %% Problem Base Class
    % Inherit the Problem class and implement the abstract functions

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties
        name % problem's name

        % run parameter
        sub_pop = 50 % each task population size
        sub_eva % num of max evaluation for each task

        % special parameter
        Dim = 50 % for CMT, CEC10-CSO, CEC17-CSO
        task_num = 50 % for WCCI20_MaTSO
    end

    methods
        function obj = Problem(varargin)
            % problem constructor, cannot be changed
            if length(varargin) >= 1
                obj.name = char(varargin{1});
            else
                obj.name = 'problem';
            end
        end

        function name = getName(obj)
            % get problem's name, cannot be changed
            name = obj.name;
        end

        function obj = setName(obj, name)
            % set problem's name, cannot be changed
            obj.name = name;
        end

        function RunPara = getRunParameter(obj)
            % get RunPara, cannot be changed
            RunPara = {'N: Each Task Population Size', num2str(obj.sub_pop), ...
                    'E: Each Task Evaluation Max', num2str(obj.sub_eva)};
        end

        function RunParaList = getRunParameterList(obj)
            % get RunParaList, cannot be changed
            RunParaList = [obj.sub_pop, obj.sub_eva];
        end

        function obj = setRunParameter(obj, RunPara)
            % set RunPara, cannot be changed
            obj.sub_pop = str2double(RunPara{1});
            obj.sub_eva = str2double(RunPara{2});
        end

        function Parameter = getParameter(obj)
            % get problem's parameter
            % return parameter, contains {para1, value1, para2, value2, ...} (string)
            Parameter = obj.getRunParameter();
        end

        function obj = setParameter(obj, Parameter)
            % set problem's parameter
            % arg Parameter, contains {value1, value2, ...} (string)
            obj.setRunParameter(Parameter);
        end
    end

    methods (Abstract)
        getTasks(obj) % get problem's tasks
        % return tasks, contains [task1, task2, ...]
        % taski in tasks, contains task.dims, task.fnc, task.Lb, task.Ub
    end
end
