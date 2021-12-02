classdef MFEA_AKT < Algorithm
    % @article{zhou2020MFEA - AKT,
    %     author = {Zhou, Lei and Feng, Liang and Tan, Kay Chen and Zhong, Jinghui and Zhu, Zexuan and Liu, Kai and Chen, Chao},
    %     journal = {IEEE Transactions on Cybernetics},
    %     title = {Toward Adaptive Knowledge Transfer in Multifactorial Evolutionary Computation},
    %     year = {2021},
    %     volume = {51},
    %     number = {5},
    %     pages = {2563 - 2576},
    %     doi = {10.1109 / TCYB.2020.2974100},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        ginterval = 20;
        mu = 2; % index of Simulated Binary Crossover (tunable)
        mum = 5; % index of polynomial mutation
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'ginterval', num2str(obj.ginterval), ...
                        'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.ginterval = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            tic

            fnceval_calls = 0;
            cfb_record = [];

            % initialize
            [population, calls] = initialize(IndividualAKT, pop_size, Tasks, length(Tasks));
            fnceval_calls = fnceval_calls + calls;

            for t = 1:length(Tasks)
                for i = 1:pop_size
                    factorial_costs(i) = population(i).factorial_costs(t);
                end
                [~, rank] = sort(factorial_costs);
                for i = 1:pop_size
                    population(i).factorial_ranks(t) = rank(i);
                end
                bestobj(t) = population(rank(1)).factorial_costs(t);
                data.bestX{t} = population(rank(1)).rnvec;
                data.convergence(t, 1) = bestobj(t);
            end

            % calculate skill factor and initialize akt parameter
            for i = 1:pop_size
                min_rank = min(population(i).factorial_ranks);
                min_idx = find(population(i).factorial_ranks == min_rank);
                population(i).skill_factor = min_idx(randi(length(min_idx)));
                population(i).factorial_costs(1:population(i).skill_factor - 1) = inf;
                population(i).factorial_costs(population(i).skill_factor + 1:end) = inf;

                population(i).isTran = 0;
                population(i).cx_factor = randi(6);
                population(i).parNum = 0;
            end

            generation = 1;
            while generation < iter_num && fnceval_calls < eva_num
                generation = generation + 1;

                [offspring, calls] = OperatorAKT.generateMF(1, population, Tasks, obj.rmp, obj.mu, obj.mum);
                fnceval_calls = fnceval_calls + calls;

                % calculate best cx_factor
                imp_num = zeros(1, 6);
                for i = 1:length(offspring)
                    if offspring(i).parNum ~= 0
                        cfc = offspring(i).factorial_costs(offspring(i).skill_factor);
                        pfc = population(offspring(i).parNum).factorial_costs(population(offspring(i).parNum).skill_factor);
                        if (pfc - cfc) / pfc > imp_num(offspring(i).cx_factor)
                            imp_num(offspring(i).cx_factor) = (pfc - cfc) / pfc;
                        end
                    end
                end
                % ginterval
                prcfb_count = zeros(1, 6);
                if any(imp_num)
                    [max_num, max_idx] = max(imp_num);
                else % have not better cx_factor
                    if generation <= obj.ginterval + 1 % former generation
                        prcfb_count(cfb_record(2:generation - 1)) = prcfb_count(cfb_record(2:generation - 1)) + 1;
                    else
                        prcfb_count(cfb_record(generation - obj.ginterval:generation - 1)) = prcfb_count(cfb_record(generation - obj.ginterval:generation - 1)) + 1;
                    end
                    [max_num, max_idx] = max(prcfb_count);
                end
                cfb_record(generation) = max_idx;
                % adaptive cx_factor
                for i = 1:length(offspring)
                    if offspring(i).parNum ~= 0
                        cfc = offspring(i).factorial_costs(offspring(i).skill_factor);
                        pfc = population(offspring(i).parNum).factorial_costs(population(offspring(i).parNum).skill_factor);
                        if (pfc - cfc) / pfc < 0
                            offspring(i).cx_factor = max_idx;
                        end
                    else
                        p = [max_idx, randi(6)];
                        offspring(i).cx_factor = p(randi(2));
                    end
                end

                % selection
                population = [population, offspring];
                for t = 1:length(Tasks)
                    for i = 1:length(population)
                        factorial_costs(i) = population(i).factorial_costs(t);
                    end
                    [bestobj_offspring, idx] = min(factorial_costs);
                    if bestobj_offspring < bestobj(t)
                        bestobj(t) = bestobj_offspring;
                        data.bestX{t} = population(idx).rnvec;
                    end
                    data.convergence(t, generation) = bestobj(t);

                    [~, rank] = sort(factorial_costs);
                    for i = 1:length(population)
                        population(rank(i)).factorial_ranks(t) = i;
                    end
                end
                for i = 1:length(population)
                    population(i).scalar_fitness = 1 / min([population(i).factorial_ranks]);
                    population(i).isTran = 0;
                    population(i).parNum = 0;
                end
                [~, rank] = sort(- [population.scalar_fitness]);
                population = population(rank(1:pop_size));
            end
            % map to real bound
            for t = 1:length(Tasks)
                data.bestX{t} = Tasks(t).Lb + data.bestX{t} .* (Tasks(t).Ub - Tasks(t).Lb);
            end
            data.clock_time = toc;
        end
    end
end
