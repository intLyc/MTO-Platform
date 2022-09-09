classdef CEC20_RWCO55 < Problem
    % <ST-SO> <Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = CEC20_RWCO55(varargin)
            obj = obj@Problem(varargin);
            obj.maxFE = eva_CEC20_RWCO(55);
        end

        function setTasks(obj)
            Tasks(1) = benchmark_CEC20_RWCO(55);
            obj.T = 1;
            obj.D(1) = Tasks(1).Dim;
            obj.Fnc{1} = Tasks(1).Fnc;
            obj.Lb{1} = Tasks(1).Lb;
            obj.Ub{1} = Tasks(1).Ub;
        end
    end
end
