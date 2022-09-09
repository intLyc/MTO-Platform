classdef ATF1 < Problem
    % <ST-SO> <Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = ATF1(varargin)
            obj = obj@Problem(varargin);
            obj.maxFE = 60 * 500;
        end

        function setTasks(obj)
            obj.T = 1;
            obj.D(1) = 2;
            obj.Fnc{1} = @(x)ATF_Func(x, 1);
            obj.Lb{1} = [-10, -5];
            obj.Ub{1} = [5, 5];
        end
    end
end
