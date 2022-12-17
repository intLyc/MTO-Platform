classdef FROFI < Algorithm
% <Single-task> <Single-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @Article{Wang2016FROFI,
%   title    = {Incorporating Objective Function Information Into the Feasibility Rule for Constrained Evolutionary Optimization},
%   author   = {Wang, Yong and Wang, Bing-Chuan and Li, Han-Xiong and Yen, Gary G.},
%   journal  = {IEEE Transactions on Cybernetics},
%   year     = {2016},
%   number   = {12},
%   pages    = {2938-2952},
%   volume   = {46},
%   doi      = {10.1109/TCYB.2015.2493239},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

methods
    function run(Algo, Prob)
        F_pool = [0.6, 0.8, 1.0];
        CR_pool = [0.1, 0.2, 1.0];

        % Initialization
        population = Initialization(Algo, Prob, Individual);

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                % Generation
                offspring = Algo.Generation(population{t}, F_pool, CR_pool);
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                archive = offspring(offspring.CVs > population{t}.CVs & offspring.Objs < population{t}.Objs);
                [population{t}] = Selection_Tournament(population{t}, offspring);

                % Replace Operator
                N = round(max(5, length(population{t}) / 2)); % the maximum number of vectors to be replaced
                Nf = round(length(population{t}) / N); % the number of parts to be divided
                [~, rank] = sort(population{t}.Objs, 'descend');
                population{t} = population{t}(rank);
                for i = 1:floor(length(population{t}) / Nf)
                    len = length(archive);
                    if len == 0
                        break;
                    end
                    current = (i - 1) * Nf + 1:i * Nf;
                    [~, worst] = max([population{t}(current).CV]);
                    [~, best] = min([archive.CV]);

                    if archive(best).Obj < population{t}(current(worst)).Obj
                        population{t}(current(worst)) = archive(best);
                        archive(best) = [];
                    end
                end

                % Mutation Operator
                if min([population{t}.CV]) > 0
                    [~, worst] = max([population{t}.CV]);

                    temp = population{t}(randi(end));
                    k = randi(length(temp.Dec));
                    temp.Dec(k) = rand();
                    temp = Algo.Evaluation(temp, Prob, t);

                    if population{t}(worst).Obj > temp.Obj
                        population{t}(worst) = temp;
                    end
                end
            end
        end
    end

    function offspring = Generation(Algo, population, F_pool, CR_pool)
        [~, best] = min(population.Objs);

        for i = 1:length(population)
            offspring(i) = population(i);
            A = randperm(length(population), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
            F = F_pool(randi(length(F_pool)));
            CR = CR_pool(randi(length(CR_pool)));

            if rand() < 0.5
                % rand-to-best
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
end
end
