classdef EO < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Faramarzi2020EO,
%   title   = {Equilibrium Optimizer: A Novel Optimization Algorithm},
%   author  = {Afshin Faramarzi and Mohammad Heidarinejad and Brent Stephens and Seyedali Mirjalili},
%   journal = {Knowledge-Based Systems},
%   year    = {2020},
%   issn    = {0950-7051},
%   pages   = {105190},
%   volume  = {191},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    A1 = 2
    A2 = 1
    V = 1
    GP = 0.5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'A1', num2str(Algo.A1), ...
                'A2', num2str(Algo.A2), ...
                'V', num2str(Algo.V), ...
                'GP', num2str(Algo.GP)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.A1 = str2double(Parameter{i}); i = i + 1;
        Algo.A2 = str2double(Parameter{i}); i = i + 1;
        Algo.V = str2double(Parameter{i}); i = i + 1;
        Algo.GP = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual);
        dim = max(Prob.D);
        for t = 1:Prob.T
            for i = 1:4
                Ceq{t}(i) = Individual();
                Ceq{t}(i).Dec = zeros(1, dim);
                Ceq{t}(i).Obj = inf;
                Ceq{t}(i).CV = inf;
            end
        end

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                for i = 1:Prob.N
                    pObj = population{t}(i).Obj;
                    pCV = population{t}(i).CV;
                    cObjs = Ceq{t}.Objs;
                    cCVs = Ceq{t}.CVs;
                    if pCV < cCVs(1) || (pCV == cCVs(1) && pObj < cObjs(1))
                        Ceq{t}(1) = population{t}(i);
                    elseif pCV < cCVs(2) || (pCV == cCVs(2) && pObj < cObjs(2))
                        Ceq{t}(2) = population{t}(i);
                    elseif pCV < cCVs(3) || (pCV == cCVs(3) && pObj < cObjs(3))
                        Ceq{t}(3) = population{t}(i);
                    elseif pCV < cCVs(4) || (pCV == cCVs(4) && pObj < cObjs(4))
                        Ceq{t}(4) = population{t}(i);
                    end
                end
                Ceq_ave = Individual();
                Ceq_ave.Dec = mean(Ceq{t}.Decs);
                C_pool = [Ceq{t}, Ceq_ave];
                ratio = (1 - Algo.FE / Prob.maxFE)^(Algo.A2 * Algo.FE / Prob.maxFE);
                % Generation
                offspring = Algo.Generation(population{t}, C_pool, ratio);
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                population{t} = Selection_Tournament(population{t}, offspring);
            end
        end
    end

    function offspring = Generation(Algo, population, C_pool, ratio)
        dim = length(population(1).Dec);
        for i = 1:length(population)
            offspring(i) = population(i);
            lambda = rand(1, dim);
            r = rand(1, dim);
            CeqDec = C_pool(randi(length(C_pool))).Dec;
            F = Algo.A1 * sign(r - 0.5) .* (exp(-lambda .* ratio) - 1);
            r1 = rand(); r2 = rand();
            GCP = 0.5 * r1 * ones(1, dim) * (r2 >= Algo.GP);
            G0 = GCP .* (CeqDec - lambda .* population(i).Dec);
            G = G0 .* F;
            offspring(i).Dec = CeqDec + (population(i).Dec - CeqDec) .* F + (G ./ lambda * Algo.V) .* (1 - F);

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end
end
end
