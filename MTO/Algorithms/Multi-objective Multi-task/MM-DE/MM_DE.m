classdef MM_DE < Algorithm
% <Multi-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Chen2018MM-DE,
%   title     = {A Fast Memetic Multi-Objective Differential Evolution for Multi-Tasking Optimization},
%   author    = {Chen, Yongliang and Zhong, Jinghui and Tan, Mingkui},
%   booktitle = {2018 IEEE Congress on Evolutionary Computation (CEC)},
%   year      = {2018},
%   pages     = {1-8},
%   doi       = {10.1109/CEC.2018.8477722},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    Alpha = 0.05
    T = 10
    LM = 3
    LN = 10
    Beta = 0.002
    Lambda = 0.5
    C = 0.1
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Alpha: K-Crossover Rate', num2str(Algo.Alpha), ...
                'T: Frequency of local search', num2str(Algo.T), ...
                'LM: Individuals for local search', num2str(Algo.LM), ...
                'LN: Neighboring points generated around', num2str(Algo.LN), ...
                'Beta: Rate to local-search each dimension', num2str(Algo.Beta), ...
                'Lambda: Shrinking rate', num2str(Algo.Lambda), ...
                'C: life span of uF and uCR', num2str(Algo.C)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.Alpha = str2double(Parameter{i}); i = i + 1;
        Algo.T = str2double(Parameter{i}); i = i + 1;
        Algo.LM = str2double(Parameter{i}); i = i + 1;
        Algo.LN = str2double(Parameter{i}); i = i + 1;
        Algo.Beta = str2double(Parameter{i}); i = i + 1;
        Algo.Lambda = str2double(Parameter{i}); i = i + 1;
        Algo.C = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization(Algo, Prob, Individual_MMDE);
        for t = 1:Prob.T
            % initialize Parameter
            uF{t} = 0.5;
            uCR{t} = 0.5;

            [rank, FrontNo] = NSGA2Sort(population{t});
            for i = 1:length(population{t})
                % Initialize Region
                population{t}(i).Reg = rand(1, max(Prob.D)) / 10;
                population{t}(i).FrontNo = FrontNo(i);
            end
            population{t} = population{t}(rank);
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                % calculate individual F and CR
                for i = 1:length(population{t})
                    population{t}(i).F = cauchyrnd(uF{t}, 0.1);
                    while (population{t}(i).F <= 0.1)
                        population{t}(i).F = cauchyrnd(uF{t}, 0.1);
                    end
                    population{t}(i).F(population{t}(i).F > 1) = 1;

                    population{t}(i).CR = normrnd(uCR{t}, 0.1);
                    population{t}(i).CR(population{t}(i).CR > 1) = 1;
                    population{t}(i).CR(population{t}(i).CR < 0.1) = 0.1;
                end

                % Generation
                task_pool = 1:Prob.T;
                task_pool(task_pool == t) = [];
                if rand() < Algo.Alpha
                    offspring = Algo.Generation([population{t}, population{task_pool(randi(length(task_pool)))}], Prob.N, (Prob.maxFE - Algo.FE) / Prob.maxFE);
                else
                    offspring = Algo.Generation(population{t}, Prob.N, (Prob.maxFE - Algo.FE) / Prob.maxFE);
                end
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);

                % Selection
                population_temp = [population{t}, offspring];
                FrontNo = NDSort(population_temp.Objs, population_temp.CVs, inf);

                old = FrontNo(1:end / 2);
                new = FrontNo(end / 2 + 1:end);

                % calculate SF SCR
                SF = [population{t}(new < old).F];
                SCR = [population{t}(new < old).CR];
                % update uF uCR
                for i = 1:length(SF)
                    newSF = sum(SF.^2) ./ sum(SF);
                    uF{t} = (1 - Algo.C) .* uF{t} + Algo.C .* newSF;
                    uCR{t} = (1 - Algo.C) .* uCR{t} + Algo.C .* mean(SCR);
                end

                population{t}(new < old) = offspring(new < old);
                archive = offspring(new == old);

                % Adaptive Local Search
                if mod(Algo.Gen, Algo.T) == 0
                    temp = find(min(old, new) == 1);
                    idx = temp(randperm(length(temp), min(length(temp), Algo.LM)));
                    for i = 1:length(idx)
                        flag = false;
                        for x = 1:Algo.LN
                            s = population{t}(idx(i));
                            l = randi(length(population{t}(idx(i)).Dec));
                            for j = 1:length(population{t}(idx(i)).Dec)
                                if (rand() < Algo.Beta) || j == l
                                    s.Dec(j) = s.Dec(j) + normrnd(0, 1) * s.Reg(j);
                                end
                                if s.Dec(j) > 1
                                    s.Dec(j) = population{t}(idx(i)).Dec(j) + rand() * (1 - population{t}(idx(i)).Dec(j));
                                end
                                if s.Dec(j) < 0
                                    s.Dec(j) = 0 + rand() * (population{t}(idx(i)).Dec(j) - 0);
                                end
                            end
                            % Compare
                            s = Algo.Evaluation(s, Prob, t);
                            FrontNo = NDSort([population{t}(idx(i)).Obj; s.Obj], [population{t}(idx(i)).CV; s.CV], inf);
                            if FrontNo(1) > FrontNo(2) % Better Search
                                population{t}(idx(i)) = s;
                                flag = true;
                            elseif FrontNo(1) == FrontNo(2)
                                archive = [archive, s];
                            end
                        end
                        % Update Region
                        if flag
                            population{t}(idx(i)).Reg = population{t}(idx(i)).Reg ./ Algo.Lambda;
                        else
                            population{t}(idx(i)).Reg = population{t}(idx(i)).Reg .* Algo.Lambda;
                        end
                    end
                end

                population{t} = [population{t}, archive];
                [rank, FrontNo] = NSGA2Sort(population{t});
                for i = 1:length(population{t})
                    population{t}(i).FrontNo = FrontNo(i);
                end
                population{t} = population{t}(rank(1:Prob.N));
            end
        end
    end

    function offspring = Generation(Algo, population, N, Reg_rate)
        rank_best = find([population.FrontNo] == 1);

        for i = 1:N
            offspring(i) = population(i);

            rbest = rank_best(randi(length(rank_best)));
            x1 = randi(length(population));
            while x1 == i || x1 == rbest
                x1 = randi(length(population));
            end
            x2 = randi(length(population));
            while x2 == i || x2 == x1 || x2 == rbest
                x2 = randi(length(population));
            end

            % Decision Variables Mutation and Crossover
            offspring(i).Dec = population(i).Dec + ...
                population(i).F * (population(rbest).Dec - population(i).Dec) + ...
                population(i).F * (population(x1).Dec - population(x2).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, population(i).CR);

            rnd_lower = 0 + rand(size(population(i).Dec)) .* (population(i).Dec - 0);
            vio_low = find(offspring(i).Dec < 0);
            offspring(i).Dec(vio_low) = rnd_lower(vio_low);
            rnd_upper = population(i).Dec + rand(size(population(i).Dec)) .* (1 - population(i).Dec);
            vio_up = find(offspring(i).Dec > 1);
            offspring(i).Dec(vio_up) = rnd_upper(vio_up);

            % Region Mutation and Crossover
            offspring(i).Reg = population(i).Reg + ...
                population(i).F * (population(rbest).Reg - population(i).Reg) + ...
                population(i).F * (population(x1).Reg - population(x2).Reg);
            offspring(i).Reg = DE_Crossover(offspring(i).Reg, population(i).Reg, population(i).CR);

            maxReg = 1/10 * Reg_rate;
            offspring(i).Reg(offspring(i).Reg > maxReg) = maxReg;
            offspring(i).Reg(offspring(i).Reg < 0) = 0;
        end
    end
end
end
