classdef WCCI20_MaTSO4 < Problem
    % <Many> <None>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = WCCI20_MaTSO4(name)
            obj = obj@Problem(name);
            obj.sub_eva = 1000 * 50;
        end

        function parameter = getParameter(obj)
            parameter = {'Task Num', num2str(obj.task_num)};
            parameter = [obj.getRunParameter(), parameter];
        end

        function obj = setParameter(obj, parameter_cell)
            obj.setRunParameter(parameter_cell(1:2));
            obj.task_num = str2double(parameter_cell{3});
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_WCCI20_MaTSO(4, obj.task_num);
        end
    end
end
