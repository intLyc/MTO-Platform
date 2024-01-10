classdef MTDE_MKTA < Algorithm
% <Multi-task/Many-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Li2024MTDE-MKTA,
%   title    = {Multiobjective Multitask Optimization with Multiple Knowledge Types and Transfer Adaptation},
%   author   = {Li, Yanchi and Gong, Wenyin},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2024},
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
    Tau1 = 0.2
    Tau2 = 0.1
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Tau1: F-CR', num2str(Algo.Tau1), ...
                'Tau2: TR-KP', num2str(Algo.Tau2)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Tau1 = str2double(Parameter{i}); i = i + 1;
        Algo.Tau2 = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual_MKTA);
        for t = 1:Prob.T
            for i = 1:Prob.N
                population{t}(i).F = 0.2 + rand();
                population{t}(i).CR = rand();
                population{t}(i).TR = rand(); % Knowledge transfer rate
                population{t}(i).KP = rand(); % Knowledge type proportion
            end
            [population{t}, Fitness{t}] = Selection_SPEA2(population{t}, Prob.N);
            decs = population{t}.Decs;
            model{t}.mean = mean(decs);
            model{t}.std = std(decs) +1e-100;
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                [~, rank{t}] = sort(Fitness{t});
                [~, rank{t}] = sort(rank{t});
                decs = population{t}.Decs;
                alpha = 0.5;
                model{t}.mean = alpha * model{t}.mean + (1 - alpha) * mean(decs);
                model{t}.std = alpha * model{t}.std + (1 - alpha) * (std(decs)) +1e-100;
            end
            for t = 1:Prob.T
                offspring{t} = Algo.Generation(population, rank, model, t);
            end

            for t = 1:Prob.T
                % Evaluation
                offspring{t} = Algo.Evaluation(offspring{t}, Prob, t);
                % Selection
                population{t} = [population{t}, offspring{t}];
                [population{t}, Fitness{t}, Next] = Selection_SPEA2(population{t}, Prob.N);
            end
        end
    end

    function offspring = Generation(Algo, population, rank, model, t)
        for i = 1:length(population{t})
            offspring(i) = population{t}(i);

            % Parameter disturbance
            offspring(i).F = normrnd(population{t}(i).F, 0.1);
            offspring(i).F = min(max(offspring(i).F, 0.2), 1.2);
            offspring(i).CR = normrnd(population{t}(i).CR, 0.1);
            offspring(i).CR = min(max(offspring(i).CR, 0), 1);
            offspring(i).TR = normrnd(population{t}(i).TR, 0.1);
            offspring(i).TR = min(max(offspring(i).TR, 0), 1);
            offspring(i).KP = normrnd(population{t}(i).KP, 0.1);
            if offspring(i).KP < 0
                offspring(i).KP = 1 + offspring(i).KP;
            elseif offspring(i).KP > 1
                offspring(i).KP = offspring(i).KP - 1;
            end

            % Parameter mutation
            if rand() < Algo.Tau1
                offspring(i).F = 0.2 + rand();
            end
            if rand() < Algo.Tau1
                offspring(i).CR = rand();
            end
            if rand() < Algo.Tau2
                offspring(i).TR = rand();
            end
            if rand() < Algo.Tau2
                offspring(i).KP = rand();
            end

            % Select individuals (rank-DE)
            Np = length(population{t});
            x1 = randi(Np);
            while rand() > (Np - rank{t}(x1)) / Np || x1 == i
                x1 = randi(Np);
            end
            x2 = randi(Np);
            while rand() > (Np - rank{t}(x2)) / Np || x2 == i || x2 == x1
                x2 = randi(Np);
            end
            x3 = randi(Np);
            while x3 == i || x3 == x1 || x3 == x2
                x3 = randi(Np);
            end
            xDeci = population{t}(i).Dec;
            xDec1 = population{t}(x1).Dec;
            xDec2 = population{t}(x2).Dec;
            xDec3 = population{t}(x3).Dec;

            % Knowledge transfer
            if rand() < offspring(i).TR
                k = randi(length(population)); % help task
                while (k == t), k = randi(length(population)); end
                Np = length(population{k});

                rnd = offspring(i).KP;
                if rnd > 1/2
                    xDeck = population{k}(randi(Np)).Dec;
                else
                    xDeck = population{k}(randi(Np)).Dec;
                    xDeck = (xDeck -model{k}.mean) ./ model{k}.std;
                    xDeck = model{t}.mean + model{t}.std .* xDeck;
                end
                xDec2 = xDeck;
            end

            offspring(i).Dec = xDec1 + offspring(i).F * (xDec2 - xDec3);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, xDeci, offspring(i).CR);
            offspring(i).Dec = min(max(offspring(i).Dec, 0), 1);
        end
    end
end
end
