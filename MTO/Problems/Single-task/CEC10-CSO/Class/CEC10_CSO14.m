classdef CEC10_CSO14 < Problem
    % <ST-SO> <Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function Prob = CEC10_CSO14(varargin)
            Prob = Prob@Problem(varargin);
            Prob.maxFE = 20000 * Prob.D;
        end

        function Parameter = getParameter(Prob)
            Parameter = {'Dim', num2str(Prob.D)};
            Parameter = [Prob.getRunParameter(), Parameter];
        end

        function Prob = setParameter(Prob, Parameter)
            D = str2double(Parameter{3});
            if D ~= 10 && D ~= 30
                [~, idx] = min([abs(D - 10), abs(D - 30)]);
                if idx == 1
                    D = 10;
                else
                    D = 30;
                end
            end
            if Prob.D == D
                Prob.setRunParameter(Parameter(1:2));
            else
                Prob.D = D;
                Prob.maxFE = 20000 * Prob.D;
                Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
            end
        end

        function setTasks(Prob)
            if isempty(Prob.D)
                D = Prob.defaultD;
                if D ~= 10 && D ~= 30
                    [~, idx] = min([abs(D - 10), abs(D - 30)]);
                    if idx == 1
                        D = 10;
                    else
                        D = 30;
                    end
                end
                Prob.D = D;
            end

            Tasks(1) = benchmark_CEC10_CSO(14, Prob.D);
            Prob.T = 1;
            Prob.D(1) = Tasks(1).Dim;
            Prob.Fnc{1} = Tasks(1).Fnc;
            Prob.Lb{1} = Tasks(1).Lb;
            Prob.Ub{1} = Tasks(1).Ub;
        end
    end
end
