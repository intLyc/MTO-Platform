classdef AT_MFEA < Algorithm
% <Multi-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @article{Xue2020AT-MFEA,
%   title      = {Affine Transformation-Enhanced Multifactorial Optimization for Heterogeneous Problems},
%   author     = {Xue, Xiaoming and Zhang, Kai and Tan, Kay Chen and Feng, Liang and Wang, Jian and Chen, Guodong and Zhao, Xinggang and Zhang, Liming and Yao, Jun},
%   doi        = {10.1109/TCYB.2020.3036393},
%   journal    = {IEEE Transactions on Cybernetics},
%   pages      = {1-15},
%   year       = {2020}
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    RMP = 0.3
    MuC = 2
    MuM = 5
    Swap = 0.5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM), ...
                'Swap: Variable Swap Probability', num2str(Algo.Swap)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.RMP = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
        Algo.Swap = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization_MF(Algo, Prob, Individual_MF);
        % Initialize Affine Transformation
        [Mu_tasks, Sigma_tasks] = InitialDistribution(population, Prob.T);

        while Algo.notTerminated(Prob)
            % Generation
            offspring = Algo.Generation(population, Mu_tasks, Sigma_tasks);
            % Evaluation
            offspring_temp = Individual_MF.empty();
            for t = 1:Prob.T
                offspring_t = offspring([offspring.MFFactor] == t);
                offspring_t = Algo.Evaluation(offspring_t, Prob, t);
                for i = 1:length(offspring_t)
                    offspring_t(i).MFObj = inf(1, Prob.T);
                    offspring_t(i).MFCV = inf(1, Prob.T);
                    offspring_t(i).MFObj(t) = offspring_t(i).Obj;
                    offspring_t(i).MFCV(t) = offspring_t(i).CV;
                end
                offspring_temp = [offspring_temp, offspring_t];
            end
            offspring = offspring_temp;
            % Selection
            population = Selection_MF(population, offspring, Prob);
            [Mu_tasks, Sigma_tasks] = DistributionUpdate(Mu_tasks, Sigma_tasks, population, Prob.T);
        end
    end

    function offspring = Generation(Algo, population, Mu_tasks, Sigma_tasks)
        indorder = randperm(length(population));
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(population) / 2));
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);

            if (population(p1).MFFactor == population(p2).MFFactor)
                % crossover
                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
                % mutation
                offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
                offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.MuM);
                % variable swap (uniform X)
                swap_indicator = (rand(1, length(population(p1).Dec)) >= Algo.Swap);
                temp = offspring(count + 1).Dec(swap_indicator);
                offspring(count + 1).Dec(swap_indicator) = offspring(count).Dec(swap_indicator);
                offspring(count).Dec(swap_indicator) = temp;
                % imitation
                p = [p1, p2];
                offspring(count).MFFactor = population(p(randi(2))).MFFactor;
                offspring(count + 1).MFFactor = population(p(randi(2))).MFFactor;
            elseif rand() < Algo.RMP
                % affine transformation
                pm1 = population(p1); pm2 = population(p2);
                pm1.Dec = AT_Transfer(population(p1).Dec, Mu_tasks{population(p1).MFFactor}, Sigma_tasks{population(p1).MFFactor}, Mu_tasks{population(p2).MFFactor}, Sigma_tasks{population(p2).MFFactor});
                pm2.Dec = AT_Transfer(population(p2).Dec, Mu_tasks{population(p2).MFFactor}, Sigma_tasks{population(p2).MFFactor}, Mu_tasks{population(p1).MFFactor}, Sigma_tasks{population(p1).MFFactor});
                % crossover
                offspring(count).Dec = GA_Crossover(pm1.Dec, population(p2).Dec, Algo.MuC);
                offspring(count + 1).Dec = GA_Crossover(population(p1).Dec, pm2.Dec, Algo.MuC);
                % mutation
                offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
                offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.MuM);
                % imitation
                p = [p1, p2];
                offspring(count).MFFactor = population(p(randi(2))).MFFactor;
                offspring(count + 1).MFFactor = population(p(randi(2))).MFFactor;
            else
                % Randomly pick another individual from the same task
                p = [p1, p2];
                for x = 1:2
                    find_idx = find([population.MFFactor] == population(p(x)).MFFactor);
                    idx = find_idx(randi(length(find_idx)));
                    while idx == p(x)
                        idx = find_idx(randi(length(find_idx)));
                    end
                    offspring_temp = population(idx);
                    % crossover
                    [offspring(count + x - 1).Dec, offspring_temp.Dec] = GA_Crossover(population(p(x)).Dec, population(idx).Dec, Algo.MuC);
                    % mutation
                    offspring(count + x - 1).Dec = GA_Mutation(offspring(count + x - 1).Dec, Algo.MuM);
                    offspring_temp.Dec = GA_Mutation(offspring_temp.Dec, Algo.MuM);
                    % variable swap (uniform X)
                    swap_indicator = (rand(1, length(population(p(x)).Dec)) >= Algo.Swap);
                    offspring(count + x - 1).Dec(swap_indicator) = offspring_temp.Dec(swap_indicator);
                    % imitate
                    offspring(count + x - 1).MFFactor = population(p(x)).MFFactor;
                end
            end
            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end
end
end
