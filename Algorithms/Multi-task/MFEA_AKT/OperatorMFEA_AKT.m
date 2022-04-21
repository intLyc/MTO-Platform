classdef OperatorMFEA_AKT < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(callfun, population, Tasks, rmp, mu, mum)
            Individual_class = class(population(1));
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = feval(Individual_class);
                offspring(count).factorial_costs = inf(1, length(Tasks));
                offspring(count).constraint_violation = inf(1, length(Tasks));
                offspring(count + 1) = feval(Individual_class);
                offspring(count + 1).factorial_costs = inf(1, length(Tasks));
                offspring(count + 1).constraint_violation = inf(1, length(Tasks));

                u = rand(1, max([Tasks.dims]));
                cf = zeros(1, max([Tasks.dims]));
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
                if (population(p1).skill_factor == population(p2).skill_factor) || rand < rmp
                    % crossover
                    p = [p1, p2];
                    if population(p1).skill_factor == population(p2).skill_factor
                        offspring(count) = OperatorGA.crossover(offspring(count), population(p1), population(p2), cf);
                        offspring(count + 1) = OperatorGA.crossover(offspring(count + 1), population(p2), population(p1), cf);
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
                    % % mutate
                    % offspring(count) = OperatorGA.mutate(offspring(count), max([Tasks.dims]), mum);
                    % offspring(count + 1) = OperatorGA.mutate(offspring(count + 1), max([Tasks.dims]), mum);
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
                        offspring(count + x - 1) = OperatorGA.mutate(population(p(x)), max([Tasks.dims]), mum);
                        % imitate
                        offspring(count + x - 1).skill_factor = population(p(x)).skill_factor;
                    end
                end
                for x = count:count + 1
                    offspring(x).rnvec(offspring(x).rnvec > 1) = 1;
                    offspring(x).rnvec(offspring(x).rnvec < 0) = 0;
                end
                count = count + 2;
            end
            if callfun
                offspring_temp = feval(Individual_class).empty();
                calls = 0;
                for t = 1:length(Tasks)
                    offspring_t = offspring([offspring.skill_factor] == t);
                    [offspring_t, cal] = evaluate(offspring_t, Tasks(t), t);
                    offspring_temp = [offspring_temp, offspring_t];
                    calls = calls + cal;
                end
                offspring = offspring_temp;
            else
                calls = 0;
            end
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
                    object = OperatorGA.crossover(object, p1, p2, cf);
            end
        end

        % Twopoint crossover
        function object = tpcrossover(object, p1, p2)
            i = randi([1, length(p1.rnvec)], 1, 1);
            j = randi([1, length(p1.rnvec)], 1, 1);
            if i > j
                t = i; i = j; j = t;
            end
            t1 = p1.rnvec(1:i - 1);
            t2 = p2.rnvec(i:j);
            t3 = p1.rnvec(j + 1:end);
            object.rnvec = [t1 t2 t3];
        end

        % Uniform crossover
        function object = ufcrossover(object, p1, p2)
            i = 1;
            while i <= length(p1.rnvec)
                u = randi([0, 1], 1, 1);
                if u == 0
                    object.rnvec(i) = p1.rnvec(i);
                else
                    object.rnvec(i) = p2.rnvec(i);
                end
                i = i + 1;
            end
        end

        % Arithmetical crossover
        function object = aricrossover(object, p1, p2)
            i = 1; len = length(p1.rnvec);
            r = 0.25;
            while i <= len
                object.rnvec(i) = r * p1.rnvec(i) + (1 - r) * p2.rnvec(i);
                i = i + 1;
            end
        end

        % Geometric crossover
        function object = geocrossover(object, p1, p2)
            i = 1; len = length(p1.rnvec);
            r = 0.2;
            while i <= len
                object.rnvec(i) = p1.rnvec(i)^r * p2.rnvec(i)^(1 - r);
                i = i + 1;
            end
        end

        % BLX-a crossover
        function object = blxacrossover(object, p1, p2, a)
            i = 1; len = length(p1.rnvec);
            while i <= len
                if p1.rnvec(i) < p2.rnvec(i)
                    Cmin = p1.rnvec(i);
                    Cmax = p2.rnvec(i);
                else
                    Cmin = p2.rnvec(i);
                    Cmax = p1.rnvec(i);
                end
                I = Cmax - Cmin;
                object.rnvec(i) = (Cmin - I * a) + (I + 2 * I * a) * rand(1, 1);
                i = i + 1;
            end
        end
    end
end
