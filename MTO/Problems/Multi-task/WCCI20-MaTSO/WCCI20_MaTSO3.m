classdef WCCI20_MaTSO3 < Problem
    % <MaT-SO> <None>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = WCCI20_MaTSO3(varargin)
            obj = obj@Problem(varargin);
            obj.maxFE = 1000 * 50 * obj.defaultT;
        end

        function Parameter = getParameter(obj)
            Parameter = {'Task Num', num2str(obj.defaultT)};
            Parameter = [obj.getRunParameter(), Parameter];
        end

        function obj = setParameter(obj, Parameter)
            obj.defaultT = str2double(Parameter{3});
            obj.setRunParameter(Parameter(1:2));
        end

        function setTasks(obj)
            Tasks = benchmark_WCCI20_MaTSO(3, obj.defaultT);
            obj.T = length(Tasks);
            for t = 1:obj.T
                obj.D(t) = Tasks(t).Dim;
                obj.Fnc{t} = Tasks(t).Fnc;
                obj.Lb{t} = Tasks(t).Lb;
                obj.Ub{t} = Tasks(t).Ub;
            end
        end
    end
end
