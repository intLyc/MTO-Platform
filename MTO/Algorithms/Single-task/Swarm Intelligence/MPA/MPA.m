classdef MPA < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Faramarzi2020MPA,
%   title   = {Marine Predators Algorithm: A Nature-inspired Metaheuristic},
%   author  = {Afshin Faramarzi and Mohammad Heidarinejad and Seyedali Mirjalili and Amir H. Gandomi},
%   journal = {Expert Systems with Applications},
%   year    = {2020},
%   issn    = {0957-4174},
%   pages   = {113377},
%   volume  = {152},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    FADs = 0.2
    P = 0.5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'FADs', num2str(Algo.FADs), ...
                'P', num2str(Algo.P)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.FADs = str2double(Parameter{i}); i = i + 1;
        Algo.P = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual);
        dim = max(Prob.D);

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                CF = (1 - Algo.FE / Prob.maxFE)^(2 * Algo.FE / Prob.maxFE);
                RL = 0.05 * Algo.Levy(Prob.N, dim, 1.5);
                RB = randn(Prob.N, dim);
                if Algo.FE < Prob.maxFE / 3
                    Phase = 1;
                elseif Algo.FE < Prob.maxFE * 2/3
                    Phase = 2;
                else
                    Phase = 3;
                end
                % Generation
                offspring = Algo.Generation(population{t}, t, CF, RL, RB, Phase);

                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                population{t} = Selection_Tournament(population{t}, offspring);
            end
        end
    end

    function offspring = Generation(Algo, population, t, CF, RL, RB, Phase)
        n = length(population);
        dim = length(population(1).Dec);
        for i = 1:n
            offspring(i) = population(i);
            R = rand(1, dim);
            switch Phase
                case 1
                    stepsize = RB(i, :) .* (Algo.Best{t}.Dec - RB(i, :) .* population(i).Dec);
                    offspring(i).Dec = population(i).Dec + Algo.P * R .* stepsize;
                case 2
                    if i > n / 2
                        stepsize = RB(i, :) .* (RB(i, :) .* Algo.Best{t}.Dec - population(i).Dec);
                        offspring(i).Dec = Algo.Best{t}.Dec + Algo.P * CF * stepsize;
                    else
                        stepsize = RL(i, :) .* (Algo.Best{t}.Dec - RL(i, :) .* population(i).Dec);
                        offspring(i).Dec = population(i).Dec + Algo.P * R .* stepsize;
                    end
                case 3
                    stepsize = RL(i, :) .* (RL(i, :) .* Algo.Best{t}.Dec - population(i).Dec);
                    offspring(i).Dec = Algo.Best{t}.Dec + Algo.P * CF * stepsize;
            end

        end

        if rand() < Algo.FADs
            U = rand(n, dim) < Algo.FADs;
            for i = 1:n
                offspring(i).Dec = offspring(i).Dec + CF * rand(1, dim) .* U(i, :);
            end
        else
            r = rand();
            ridx1 = randperm(n);
            ridx2 = randperm(n);
            for i = 1:n
                stepsize = (Algo.FADs * (1 - r) + r) * (offspring(ridx1(i)).Dec - offspring(ridx2(i)).Dec);
                offspring(i).Dec = offspring(i).Dec + stepsize;
            end
        end

        for i = 1:n
            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end

    function [z] = Levy(Algo, n, m, beta)
        num = gamma(1 + beta) * sin(pi * beta / 2); % used for Numerator
        den = gamma((1 + beta) / 2) * beta * 2^((beta - 1) / 2); % used for Denominator
        sigma_u = (num / den)^(1 / beta); % Standard deviation
        u = random('Normal', 0, sigma_u, n, m);
        v = random('Normal', 0, 1, n, m);
        z = u ./ (abs(v).^(1 / beta));
    end
end
end
