classdef ATF2 < Problem
    % <Single> <Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = ATF2(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 60 * 500;
        end

        function Tasks = getTasks(obj)
            Task.Lb = [-10, -5];
            Task.Ub = [5, 5];
            Task.dims = 2;
            Task.fnc = @(x)ATF_Func(x, 2);
            Tasks(1) = Task;
        end
    end
end
