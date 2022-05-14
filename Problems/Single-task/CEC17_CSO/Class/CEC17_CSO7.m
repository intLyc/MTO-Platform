classdef CEC17_CSO7 < Problem
    % <Single> <Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = CEC17_CSO7(name)
            obj = obj@Problem(name);
            obj.sub_eva = 20000 * obj.dims;
        end

        function parameter = getParameter(obj)
            parameter = {'Dims', num2str(obj.dims)};
            parameter = [obj.getRunParameter(), parameter];
        end

        function obj = setParameter(obj, parameter_cell)
            obj.setRunParameter(parameter_cell(1:2));
            obj.dims = str2double(parameter_cell{3});
        end

        function Tasks = getTasks(obj)
            Tasks(1) = benchmark_CEC17_CSO(7, obj.dims);
        end
    end
end
