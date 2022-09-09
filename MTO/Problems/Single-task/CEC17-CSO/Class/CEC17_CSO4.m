classdef CEC17_CSO4 < Problem
    % <ST-SO> <Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = CEC17_CSO4(varargin)
            obj = obj@Problem(varargin);
            obj.maxFE = 20000 * obj.defaultD;
        end

        function Parameter = getParameter(obj)
            Parameter = {'Dim', num2str(obj.defaultD)};
            Parameter = [obj.getRunParameter(), Parameter];
        end

        function obj = setParameter(obj, Parameter)
            obj.defaultD = str2double(Parameter{3});
            obj.setRunParameter(Parameter(1:2));
        end

        function setTasks(obj)
            Tasks(1) = benchmark_CEC17_CSO(4, obj.defaultD);
            obj.T = 1;
            obj.D(1) = Tasks(1).Dim;
            obj.Fnc{1} = Tasks(1).Fnc;
            obj.Lb{1} = Tasks(1).Lb;
            obj.Ub{1} = Tasks(1).Ub;
        end
    end
end
