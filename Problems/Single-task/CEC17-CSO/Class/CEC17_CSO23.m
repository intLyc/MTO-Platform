classdef CEC17_CSO23 < Problem
    % <Single> <Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = CEC17_CSO23(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 20000 * obj.Dim;
        end

        function Parameter = getParameter(obj)
            Parameter = {'Dim', num2str(obj.Dim)};
            Parameter = [obj.getRunParameter(), Parameter];
        end

        function obj = setParameter(obj, Parameter)
            obj.setRunParameter(Parameter(1:2));
            obj.Dim = str2double(Parameter{3});
        end

        function Tasks = getTasks(obj)
            Tasks(1) = benchmark_CEC17_CSO(23, obj.Dim);
        end
    end
end
