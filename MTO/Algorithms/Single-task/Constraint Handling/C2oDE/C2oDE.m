classdef C2oDE < Algorithm
% <Single-task> <Single-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @Article{Wang2019C2oDE,
%   title    = {Composite Differential Evolution for Constrained Evolutionary Optimization},
%   author   = {Wang, Bing-Chuan and Li, Han-Xiong and Li, Jia-Peng and Wang, Yong},
%   journal  = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
%   year     = {2019},
%   number   = {7},
%   pages    = {1482-1495},
%   volume   = {49},
%   doi      = {10.1109/TSMC.2018.2807785},
% }
%------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    Beta = 6
    Mu = 1e-8
    P = 0.5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Beta', num2str(Algo.Beta), ...
                'Mu', num2str(Algo.Mu), ...
                'P', num2str(Algo.P)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Beta = str2double(Parameter{i}); i = i + 1;
        Algo.Mu = str2double(Parameter{i}); i = i + 1;
        Algo.P = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        F_pool = [0.6, 0.8, 1.0];
        CR_pool = [0.1, 0.2, 1.0];

        % Initialization
        population = Initialization(Algo, Prob, Individual);

        for t = 1:Prob.T
            Ep0{t} = max([population{t}.CV]);
            X{t} = 0;
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                cp = (-log(Ep0{t}) - Algo.Beta) / log(1 - Algo.P);
                % adjust the threshold
                if X{t} < Algo.P
                    Ep = Ep0{t} * (1 - X{t})^cp;
                else
                    Ep = 0;
                end
                X{t} = X{t} + (Prob.T * Prob.N * 3) / Prob.maxFE;

                % diversity restart
                if std([population{t}.CV]) < Algo.Mu && isempty(find([population{t}.CV] == 0, 1))
                    population{t} = Initialization_One(Algo, Prob, t, Individual);
                end

                % Generation
                offspring_temp = Algo.Generation(population{t}, F_pool, CR_pool);
                % Evaluation
                offspring_temp = Algo.Evaluation(offspring_temp, Prob, t);
                % Pre Selection
                for i = 1:length(population{t})
                    idx = (i - 1) * 3 + (1:3);
                    [~, ~, best] = min_FP(offspring_temp(idx).Objs, offspring_temp(idx).CVs);
                    offspring(i) = offspring_temp(idx(best));
                end
                % Selection
                population{t} = Selection_Tournament(population{t}, offspring, Ep);
            end
        end
    end

    function offspring = Generation(Algo, population, F_pool, CR_pool)
        for i = 1:length(population)
            j = (i - 1) * 3 + 1;
            offspring(j) = population(i);
            offspring(j + 1) = population(i);
            offspring(j + 2) = population(i);

            % current-to-best
            A = randperm(length(population), 3);
            A(A == i) = []; x1 = A(1); x2 = A(2);
            [~, best] = min(population.Objs);
            F = F_pool(randi(length(F_pool)));
            CR = CR_pool(randi(length(CR_pool)));
            offspring(j).Dec = population(i).Dec + ...
                F * (population(best).Dec - population(i).Dec) + ...
                F * (population(x1).Dec - population(x2).Dec);
            offspring(j).Dec = DE_Crossover(offspring(j).Dec, population(i).Dec, CR);

            % rand-to-best-modified
            A = randperm(length(population), 5);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3); x4 = A(4);
            [~, ~, best] = min_FP(population.Objs, population.CVs);
            F = F_pool(randi(length(F_pool)));
            CR = CR_pool(randi(length(CR_pool)));
            offspring(j + 1).Dec = population(x1).Dec + ...
                F * (population(best).Dec - population(x2).Dec) + ...
                F * (population(x3).Dec - population(x4).Dec);
            offspring(j + 1).Dec = DE_Crossover(offspring(j + 1).Dec, population(i).Dec, CR);

            % current-to-rand
            A = randperm(length(population), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
            F = F_pool(randi(length(F_pool)));
            offspring(j + 1).Dec = population(i).Dec + ...
                rand() * (population(x1).Dec - population(i).Dec) + ...
                F * (population(x2).Dec - population(x3).Dec);

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;

            % boundary check
            for x = j:j + 2
                % offspring(x).Dec(offspring(x).Dec > 1) = 1;
                % offspring(x).Dec(offspring(x).Dec < 0) = 0;

                vio_low = find(offspring(x).Dec < 0);
                if rand() < 0.5
                    offspring(x).Dec(vio_low) = 2 * 0 - offspring(x).Dec(vio_low);
                    vio_temp = offspring(x).Dec(vio_low) > 1;
                    offspring(x).Dec(vio_low(vio_temp)) = 1;
                else
                    if rand() < 0.5
                        offspring(x).Dec(vio_low) = 0;
                    else
                        offspring(x).Dec(vio_low) = 1;
                    end
                end
                vio_up = find(offspring(x).Dec > 1);
                if rand() < 0.5
                    offspring(x).Dec(vio_up) = 2 * 1 - offspring(x).Dec(vio_up);
                    vio_temp = offspring(x).Dec(vio_up) < 0;
                    offspring(x).Dec(vio_up(vio_temp)) = 1;
                else
                    if rand() < 0.5
                        offspring(x).Dec(vio_up) = 0;
                    else
                        offspring(x).Dec(vio_up) = 1;
                    end
                end
            end
        end
    end
end
end
