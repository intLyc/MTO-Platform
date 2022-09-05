classdef WCCI20_MaTSO5 < Problem
    % <Many> <None>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = WCCI20_MaTSO5(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 1000 * 50;
        end

        function Parameter = getParameter(obj)
            Parameter = {'Task Num', num2str(obj.task_num)};
            Parameter = [obj.getRunParameter(), Parameter];
        end

        function obj = setParameter(obj, Parameter)
            obj.setRunParameter(Parameter(1:2));
            obj.task_num = str2double(Parameter{3});
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_WCCI20_MaTSO(5, obj.task_num);
        end
    end
end
