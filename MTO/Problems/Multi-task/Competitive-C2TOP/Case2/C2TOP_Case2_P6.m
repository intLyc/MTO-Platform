classdef C2TOP_Case2_P6 < Problem
    % <Multi-task> <Single-objective> <Competitive>

    methods
        function Prob = C2TOP_Case2_P6(varargin)
            Prob = Prob@Problem(varargin);
            Prob.maxFE = 1000 * 100 * 2;
        end

        function setTasks(Prob)
            Tasks = benchmark_CEC17_MTSO_Competitive(6, 2);
            Prob.T = length(Tasks);
            for t = 1:Prob.T
                Prob.D(t) = Tasks(t).Dim;
                Prob.Fnc{t} = Tasks(t).Fnc;
                Prob.Lb{t} = Tasks(t).Lb;
                Prob.Ub{t} = Tasks(t).Ub;
            end
        end
    end
end
