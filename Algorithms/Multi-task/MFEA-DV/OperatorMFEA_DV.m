classdef OperatorMFEA_DV < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Tasks, rmp, mu, mum, p, sub_pop)
            Individual_class = class(population(1));
            count = 1;
            % knowledge transfer stategy
            P = [];
            offspring_tt = feval(Individual_class).empty();
            for t = 1:length(Tasks)
                for i = 1:sub_pop
                    Obj(i) = population(i).Obj(t);
                end
                [~, rank] = sort(Obj);
                for i = 1:sub_pop
                    population(rank(i)).factorial_ranks(t) = i;
                end
                pop_pbest{t} = rank(1:round(p * length(population)));
            end

            group = cell([1, length(Tasks)]);
            for i = 1:length(population)
                group{population(i).skill_factor} = [group{population(i).skill_factor}, i];
            end
            for i = 1:p * length(population)
                offspring_tt = feval(Individual_class);
                offspring_tt.Obj = inf(1, length(Tasks));
                for t = 1:length(group)
                    pbest = pop_pbest{t}(i);
                    other = [];
                    for w = 1:length(group)
                        if population(pbest).skill_factor ~= w
                            other = [other, group{w}];
                        end
                    end

                    other = other(randperm(length(other)));
                    x2 = other(randi(length(other)));
                    c_pbest = pop_pbest{population(x2).skill_factor}(i);
                    offspring_tt.Dec = population(pbest).Dec + population(x2).Dec - population(c_pbest).Dec;
                    offspring_tt.skill_factor = population(i).skill_factor;
                    P = [P, offspring_tt];
                end
            end
            population = [population, P];
            population = population(randperm(length(population)));
            indorder = randperm(length(population));

            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = feval(Individual_class);
                offspring(count).Obj = inf(1, length(Tasks));
                offspring(count).CV = inf(1, length(Tasks));
                offspring(count + 1) = feval(Individual_class);
                offspring(count + 1).Obj = inf(1, length(Tasks));
                offspring(count + 1).CV = inf(1, length(Tasks));

                u = rand(1, max([Tasks.Dim]));
                cf = zeros(1, max([Tasks.Dim]));
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                if (population(p1).skill_factor == population(p2).skill_factor) || rand < rmp
                    % crossover
                    offspring(count) = OperatorMFEA_DV.crossover(offspring(count), population(p1), population(p2), cf);
                    offspring(count + 1) = OperatorMFEA_DV.crossover(offspring(count + 1), population(p2), population(p1), cf);
                    % mutate
                    offspring(count) = OperatorMFEA_DV.mutate(offspring(count), max([Tasks.Dim]), mum);
                    offspring(count + 1) = OperatorMFEA_DV.mutate(offspring(count + 1), max([Tasks.Dim]), mum);
                    % imitate
                    p = [p1, p2];
                    offspring(count).skill_factor = population(p(randi(2))).skill_factor;
                    offspring(count + 1).skill_factor = population(p(randi(2))).skill_factor;
                else
                    % Randomly pick another individual from the same task
                    p = [p1, p2];
                    for x = 1:2
                        find_idx = find([population.skill_factor] == population(p(x)).skill_factor);
                        idx = find_idx(randi(length(find_idx)));
                        while idx == p(x)
                            idx = find_idx(randi(length(find_idx)));
                        end
                        % crossover
                        offspring(count + x - 1) = OperatorMFEA_DV.crossover(offspring(count + x - 1), population(p(x)), population(idx), cf);
                        % mutate
                        offspring(count + x - 1) = OperatorMFEA_DV.mutate(offspring(count + x - 1), max([Tasks.Dim]), mum);
                        % imitate
                        offspring(count + x - 1).skill_factor = population(p(x)).skill_factor;
                    end
                end
                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end

            % Evaluation
            offspring_temp = feval(Individual_class).empty();
            calls = 0;
            for t = 1:length(Tasks)
                offspring_t = offspring([offspring.skill_factor] == t);
                [offspring_t, cal] = evaluate(offspring_t, Tasks(t), t);
                offspring_temp = [offspring_temp, offspring_t];
                calls = calls + cal;
            end
        end

        function object = crossover(object, p1, p2, cf)
            % SBX - Simulated binary crossover
            object.Dec = 0.5 * ((1 + cf) .* p1.Dec + (1 - cf) .* p2.Dec);
        end

        function object = mutate(object, dim, mum)
            % Polynomial mutation
            Dec_temp = object.Dec;
            for i = 1:dim
                if rand(1) < 1 / dim
                    u = rand(1);
                    if u <= 0.5
                        del = (2 * u)^(1 / (1 + mum)) - 1;
                        Dec_temp(i) = object.Dec(i) + del * (object.Dec(i));
                    else
                        del = 1 - (2 * (1 - u))^(1 / (1 + mum));
                        Dec_temp(i) = object.Dec(i) + del * (1 - object.Dec(i));
                    end
                end
            end
            object.Dec = Dec_temp;
        end
    end
end
