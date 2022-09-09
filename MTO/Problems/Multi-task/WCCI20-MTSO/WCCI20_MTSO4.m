classdef WCCI20_MTSO4 < Problem
    % <MT-SO> <None>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = WCCI20_MTSO4(varargin)
            obj = obj@Problem(varargin);
            obj.maxFE = 1000 * 100;
        end

        function setTasks(obj)
            Tasks = benchmark_WCCI20_MTSO(4);
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
