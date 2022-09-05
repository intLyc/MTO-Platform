classdef OperatorMFEA_AKT < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Tasks, rmp, mu, mum)
            Individual_class = class(population(1));
            indorder = randperm(length(population));
            count = 1;
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
                    p = [p1, p2];
                    if population(p1).skill_factor == population(p2).skill_factor
                        offspring(count) = OperatorMFEA_AKT.crossover(offspring(count), population(p1), population(p2), cf);
                        offspring(count + 1) = OperatorMFEA_AKT.crossover(offspring(count + 1), population(p2), population(p1), cf);
                        offspring(count).cx_factor = population(p1).cx_factor;
                        offspring(count + 1).cx_factor = population(p2).cx_factor;
                        offspring(count).isTran = 0;
                        offspring(count + 1).isTran = 0;
                    else
                        alpha = population(p(randi(2))).cx_factor;
                        offspring(count) = OperatorMFEA_AKT.hyberCX(offspring(count), population(p1), population(p2), cf, alpha);
                        offspring(count + 1) = OperatorMFEA_AKT.hyberCX(offspring(count + 1), population(p2), population(p1), cf, alpha);
                        offspring(count).cx_factor = alpha;
                        offspring(count + 1).cx_factor = alpha;
                        offspring(count).isTran = 1;
                        offspring(count + 1).isTran = 1;
                    end
                    % imitate
                    rand_p = p(randi(2));
                    offspring(count).skill_factor = population(rand_p).skill_factor;
                    if offspring(count).isTran == 1
                        offspring(count).parNum = rand_p;
                    end
                    rand_p = p(randi(2));
                    offspring(count + 1).skill_factor = population(rand_p).skill_factor;
                    if offspring(count + 1).isTran == 1
                        offspring(count + 1).parNum = rand_p;
                    end
                else
                    p = [p1, p2];
                    for x = 1:2
                        % mutate
                        offspring(count + x - 1) = OperatorMFEA_AKT.mutate(population(p(x)), max([Tasks.Dim]), mum);
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
            offspring = offspring_temp;
        end

        function object = crossover(object, p1, p2, cf)
            % SBX - Simulated binary crossover
            object.Dec = 0.5 * ((1 + cf) .* p1.Dec + (1 - cf) .* p2.Dec);
        end

        function object = mutate(object, dim, mum)
            % Polynomial mutation
            dec_temp = object.Dec;
            for i = 1:dim
                if rand(1) < 1 / dim
                    u = rand(1);
                    if u <= 0.5
                        del = (2 * u)^(1 / (1 + mum)) - 1;
                        dec_temp(i) = object.Dec(i) + del * (object.Dec(i));
                    else
                        del = 1 - (2 * (1 - u))^(1 / (1 + mum));
                        dec_temp(i) = object.Dec(i) + del * (1 - object.Dec(i));
                    end
                end
            end
            object.Dec = dec_temp;
        end

        function object = hyberCX(object, p1, p2, cf, alpha)
            switch alpha
                case 1
                    object = OperatorMFEA_AKT.tpcrossover(object, p1, p2);
                case 2
                    object = OperatorMFEA_AKT.ufcrossover(object, p1, p2);
                case 3
                    object = OperatorMFEA_AKT.aricrossover(object, p1, p2);
                case 4
                    object = OperatorMFEA_AKT.geocrossover(object, p1, p2);
                case 5
                    a = 0.3;
                    object = OperatorMFEA_AKT.blxacrossover(object, p1, p2, a);
                case 6
                    object = OperatorMFEA_AKT.crossover(object, p1, p2, cf);
            end
        end

        % Twopoint crossover
        function object = tpcrossover(object, p1, p2)
            i = randi([1, length(p1.Dec)], 1, 1);
            j = randi([1, length(p1.Dec)], 1, 1);
            if i > j
                t = i; i = j; j = t;
            end
            t1 = p1.Dec(1:i - 1);
            t2 = p2.Dec(i:j);
            t3 = p1.Dec(j + 1:end);
            object.Dec = [t1 t2 t3];
        end

        % Uniform crossover
        function object = ufcrossover(object, p1, p2)
            i = 1;
            while i <= length(p1.Dec)
                u = randi([0, 1], 1, 1);
                if u == 0
                    object.Dec(i) = p1.Dec(i);
                else
                    object.Dec(i) = p2.Dec(i);
                end
                i = i + 1;
            end
        end

        % Arithmetical crossover
        function object = aricrossover(object, p1, p2)
            i = 1; len = length(p1.Dec);
            r = 0.25;
            while i <= len
                object.Dec(i) = r * p1.Dec(i) + (1 - r) * p2.Dec(i);
                i = i + 1;
            end
        end

        % Geometric crossover
        function object = geocrossover(object, p1, p2)
            i = 1; len = length(p1.Dec);
            r = 0.2;
            while i <= len
                object.Dec(i) = p1.Dec(i)^r * p2.Dec(i)^(1 - r);
                i = i + 1;
            end
        end

        % BLX-a crossover
        function object = blxacrossover(object, p1, p2, a)
            i = 1; len = length(p1.Dec);
            while i <= len
                if p1.Dec(i) < p2.Dec(i)
                    Cmin = p1.Dec(i);
                    Cmax = p2.Dec(i);
                else
                    Cmin = p2.Dec(i);
                    Cmax = p1.Dec(i);
                end
                I = Cmax - Cmin;
                object.Dec(i) = (Cmin - I * a) + (I + 2 * I * a) * rand(1, 1);
                i = i + 1;
            end
        end
    end
end
