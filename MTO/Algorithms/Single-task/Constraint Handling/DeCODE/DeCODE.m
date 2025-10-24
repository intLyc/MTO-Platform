classdef DeCODE < Algorithm
% <Single-task> <Single-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @Article{Wang2021DeCODE,
%   title    = {Decomposition-Based Multiobjective Optimization for Constrained Evolutionary Optimization},
%   author   = {Wang, Bing-Chuan and Li, Han-Xiong and Zhang, Qingfu and Wang, Yong},
%   journal  = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
%   year     = {2021},
%   number   = {1},
%   pages    = {574-587},
%   volume   = {51},
%   doi      = {10.1109/TSMC.2018.2876335},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------
properties (SetAccess = public)
    Alpha = 0.75
    Beta = 6
    Gama = 30
    Mu = 1e-8
    P = 0.85
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Alpha', num2str(Algo.Alpha), ...
                'Beta', num2str(Algo.Beta), ...
                'Gama', num2str(Algo.Gama), ...
                'Mu', num2str(Algo.Mu), ...
                'P', num2str(Algo.P)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Alpha = str2double(Parameter{i}); i = i + 1;
        Algo.Beta = str2double(Parameter{i}); i = i + 1;
        Algo.Gama = str2double(Parameter{i}); i = i + 1;
        Algo.Mu = str2double(Parameter{i}); i = i + 1;
        Algo.P = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        F_pool = [0.6, 0.8, 1.0];
        CR_pool = [0.1, 0.2, 1.0];

        % Initialization
        population = Initialization(Algo, Prob, Individual);
        archive = population;
        for t = 1:Prob.T
            Ep0{t} = min(10^(Prob.D(t) / 2), max([population{t}.CV]));
            cp{t} = (-log(Ep0{t}) - Algo.Beta) / log(1 - Algo.P);
            pmax{t} = 1;
            X{t} = 0;
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                if X{t} < Algo.P
                    Ep = Ep0{t} * (1 - X{t})^cp{t};
                else
                    Ep = 0;
                end
                X{t} = X{t} + Prob.N / (Prob.maxFE / Prob.T);

                if length(find([population{t}.CV] == 0)) > Algo.P * length(population{t})
                    Ep = 0;
                end

                rand_idx = randperm(length(population{t}));
                population{t} = population{t}(rand_idx);
                archive{t} = archive{t}(rand_idx);

                if isempty(find([population{t}.CV] < Ep))
                    pmax{t} = 1e-18;
                end

                pr = max(1e-18, pmax{t} / (1 + exp(Algo.Gama * (Algo.FE / (Prob.maxFE / Prob.T) - Algo.Alpha))));

                % diversity restart
                if std([population{t}.CV]) < Algo.Mu && isempty(find([population{t}.CV] == 0))
                    population{t} = Initialization_One(Algo, Prob, t, Individual);
                end

                weights = 0:pr / length(population{t}):pr - pr / length(population{t});
                weights(randperm(length(weights))) = weights;

                % Generation
                offspring = Algo.Generation(population{t}, F_pool, CR_pool, weights, Algo.FE / Prob.maxFE);
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);

                % selection
                [population{t}] = Algo.Selection(population{t}, offspring, weights);
                [archive{t}] = Selection_Tournament(archive{t}, offspring);
            end
        end
    end

    function offspring = Generation(Algo, population, F_pool, CR_pool, weights, rate)
        Obj = population.Objs; CV = population.CVs;
        normal_Obj = (Obj - min(Obj)) ./ (std(Obj) + eps(0));
        normal_CV = (CV - min(CV)) ./ (std(CV) + eps(0));

        for i = 1:length(population)
            offspring(i) = population(i);
            A = randperm(length(population), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
            F = F_pool(randi(length(F_pool)));
            CR = CR_pool(randi(length(CR_pool)));

            if rand() < rate
                % rand-to-best
                fit = weights(i) * normal_Obj + (1 - weights(i)) * normal_CV;
                [~, best] = min(fit);

                offspring(i).Dec = population(x1).Dec + ...
                    F * (population(best).Dec - population(x1).Dec) + ...
                    F * (population(x2).Dec - population(x3).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, CR);
            else
                % current-to-rand
                offspring(i).Dec = population(i).Dec + ...
                    rand() * (population(x1).Dec - population(i).Dec) + ...
                    F * (population(x2).Dec - population(x3).Dec);
            end

            % offspring(i).Dec(offspring(i).Dec > 1) = 1;
            % offspring(i).Dec(offspring(i).Dec < 0) = 0;

            vio_low = find(offspring(i).Dec < 0);
            if rand() < 0.5
                offspring(i).Dec(vio_low) = 2 * 0 - offspring(i).Dec(vio_low);
                vio_temp = offspring(i).Dec(vio_low) > 1;
                offspring(i).Dec(vio_low(vio_temp)) = 1;
            else
                if rand() < 0.5
                    offspring(i).Dec(vio_low) = 0;
                else
                    offspring(i).Dec(vio_low) = 1;
                end
            end
            vio_up = find(offspring(i).Dec > 1);
            if rand() < 0.5
                offspring(i).Dec(vio_up) = 2 * 1 - offspring(i).Dec(vio_up);
                vio_temp = offspring(i).Dec(vio_up) < 0;
                offspring(i).Dec(vio_up(vio_temp)) = 1;
            else
                if rand() < 0.5
                    offspring(i).Dec(vio_up) = 0;
                else
                    offspring(i).Dec(vio_up) = 1;
                end
            end
        end
    end

    function population = Selection(Algo, population, offspring, weights)
        Obj = [population.Objs', offspring.Objs'];
        CV = [population.CVs', offspring.CVs'];
        normal_Obj = (Obj - min(Obj)) ./ (std(Obj) + eps(0));
        normal_CV = (CV - min(CV)) ./ (std(CV) + eps(0));

        normal_pop_obj = normal_Obj(1:length(population));
        normal_off_obj = normal_Obj(length(population) + 1:end);
        normal_pop_cv = normal_CV(1:length(population));
        normal_off_cv = normal_CV(length(population) + 1:end);

        pop_fit = weights .* normal_pop_obj + (1 - weights) .* normal_pop_cv;
        off_fit = weights .* normal_off_obj + (1 - weights) .* normal_off_cv;

        replace = pop_fit > off_fit;
        population(replace) = offspring(replace);
    end
end
end
