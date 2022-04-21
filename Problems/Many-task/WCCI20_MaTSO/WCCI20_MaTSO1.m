classdef WCCI20_MaTSO1 < Problem
    % <Many> <None>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties
        task_size = 50;
        dims = 50;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'Task Num', num2str(obj.task_size), ...
                        'Dims', num2str(obj.dims)};
            parameter = [obj.getRunParameter(), parameter];
        end

        function obj = setParameter(obj, parameter_cell)
            obj.setRunParameter(parameter_cell(1:2));
            count = 3;
            obj.task_size = str2double(parameter_cell{count}); count = count + 1;
            obj.dims = str2double(parameter_cell{count}); count = count + 1;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_WCCI20_MaTSO(1, obj.task_size, obj.dims);
        end

    end

end
