classdef CEC20_RWCO5 < Problem
    % <Single-task> <Single-objective> <Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function Prob = CEC20_RWCO5(varargin)
            Prob = Prob@Problem(varargin);
            Prob.maxFE = eva_CEC20_RWCO(5);
        end

        function setTasks(Prob)
            Tasks(1) = benchmark_CEC20_RWCO(5);
            Prob.T = 1;
            Prob.D(1) = Tasks(1).Dim;
            Prob.Fnc{1} = Tasks(1).Fnc;
            Prob.Lb{1} = Tasks(1).Lb;
            Prob.Ub{1} = Tasks(1).Ub;
        end
    end
end
