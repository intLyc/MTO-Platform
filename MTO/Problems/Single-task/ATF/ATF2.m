classdef ATF2 < Problem
    % <ST-SO> <Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function Prob = ATF2(varargin)
            Prob = Prob@Problem(varargin);
            Prob.maxFE = 60 * 500;
        end

        function setTasks(Prob)
            Prob.T = 1;
            Prob.D(1) = 2;
            Prob.Fnc{1} = @(x)ATF_Func(x, 2);
            Prob.Lb{1} = [-10, -5];
            Prob.Ub{1} = [5, 5];
        end
    end
end
