classdef G_MFEA < Algorithm
    % <Multi> <None/Expensive>

    % @Article{Ding2019G-MFEA,
    %   author   = {Ding, Jinliang and Yang, Cuie and Jin, Yaochu and Chai, Tianyou},
    %   journal  = {IEEE Transactions on Evolutionary Computation},
    %   title    = {Generalized Multitasking for Evolutionary Optimization of Expensive Problems},
    %   year     = {2019},
    %   number   = {1},
    %   pages    = {44-58},
    %   volume   = {23},
    %   doi      = {10.1109/TEVC.2017.2785351},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        mu = 2;
        mum = 5;
        phi = 0.1;
        theta = 0.02;
        top = 0.4;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum), ...
                        'phi', num2str(obj.phi), ...
                        'theta', num2str(obj.theta), ...
                        'top', num2str(obj.top)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
            obj.phi = str2double(parameter_cell{count}); count = count + 1;
            obj.theta = str2double(parameter_cell{count}); count = count + 1;
            obj.top = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);
            tic

            % initialize
            [population, fnceval_calls, bestobj, data.bestX] = initializeMF(IndividualG, pop_size, Tasks, length(Tasks));
            data.convergence(:, 1) = bestobj;

            midnum = 0.5 * ones(1, max([Tasks.dims]));
            alpha = 0;
            meanT = {};
            transfer = {};
            inorder = {};
            for t = 1:length(Tasks)
                meanT{t} = zeros(1, max([Tasks.dims]));
            end
            for t = 1:length(Tasks)
                population_t = population([population.skill_factor] == t);
                pop_rnvec{t} = reshape([population_t.rnvec], length(population_t(1).rnvec), length(population_t))';
                pop_fit{t} = [population_t.scalar_fitness];
            end
            for t = 1:length(Tasks) - 1
                for k = (t + 1):length(Tasks)
                    inorder{t, k} = randperm(max([Tasks.dims]));
                    if Tasks(t).dims > Tasks(k).dims
                        p1 = t; p2 = k;
                    else
                        p1 = k; p2 = t;
                    end
                    index = randi(size(pop_rnvec{p1}, 1), [size(pop_rnvec{p2}, 1), 1]);
                    intpop = pop_rnvec{p1}(index, :);
                    intpop(:, inorder{t, k}(1:Tasks(p2).dims)) = pop_rnvec{p2}(:, 1:Tasks(p2).dims);
                    idx = 1;
                    for i = 1:length(population)
                        if population(i).skill_factor == p2
                            population(i).rnvec = intpop(idx, :);
                            idx = idx + 1;
                        end
                    end
                    transfer{t, k} = alpha * meanT{p1};
                    transfer{k, t} = alpha * meanT{p2};
                end
            end

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorMFEA_G.generate(1, population, Tasks, obj.rmp, obj.mu, obj.mum, transfer);
                fnceval_calls = fnceval_calls + calls;

                for t = 1:length(Tasks) - 1
                    for k = (t + 1):length(Tasks)
                        if Tasks(t).dims > Tasks(k).dims
                            p1 = t; p2 = k;
                        else
                            p1 = k; p2 = t;
                        end
                        for i = 1:length(population)
                            if population(i).skill_factor == p2
                                population(i).rnvec(1:Tasks(t).dims) = population(i).rnvec(inorder{t, k}(1:Tasks(t).dims));
                            end
                            if offspring(i).skill_factor == p2
                                offspring(i).rnvec(1:Tasks(t).dims) = population(i).rnvec(inorder{t, k}(1:Tasks(t).dims));
                            end
                        end
                        meanT{t}(1:Tasks(t).dims) = meanT{t}(inorder{t, k}(1:Tasks(t).dims));
                    end
                end

                % selection
                [population, bestobj, data.bestX] = selectMF(population, offspring, Tasks, pop_size, bestobj, data.bestX);
                data.convergence(:, generation) = bestobj;

                pop_rnvec = {};
                pop_fit = {};
                for t = 1:length(Tasks)
                    population_t = population([population.skill_factor] == t);
                    pop_rnvec{t} = reshape([population_t.rnvec], length(population_t(1).rnvec), length(population_t))';
                    pop_fit{t} = [population_t.scalar_fitness];
                end

                if generation >= obj.phi * (eva_num / pop_size) && mod(generation, round(obj.theta * (eva_num / pop_size))) == 0
                    alpha = (fnceval_calls / eva_num)^2;
                    for t = 1:length(Tasks)
                        [~, y] = sort(-pop_fit{t});
                        meanT{t} = mean(pop_rnvec{t}(y(1:round(obj.top * pop_size / length(Tasks))), :));
                    end
                end

                for t = 1:length(Tasks) - 1
                    for k = (t + 1):length(Tasks)
                        inorder{t, k} = randperm(max([Tasks.dims]));
                        if Tasks(t).dims > Tasks(k).dims
                            p1 = t; p2 = k;
                        else
                            p1 = k; p2 = t;
                        end
                        index = randi(size(pop_rnvec{p1}, 1), [size(pop_rnvec{p2}, 1), 1]);
                        intpop = pop_rnvec{p1}(index, :);
                        intpop(:, inorder{t, k}(1:Tasks(p2).dims)) = pop_rnvec{p2}(:, 1:Tasks(p2).dims);
                        idx = 1;
                        for i = 1:length(population)
                            if population(i).skill_factor == p2
                                population(i).rnvec = intpop(idx, :);
                                idx = idx + 1;
                            end
                        end
                        intmean = meanT{p1};
                        intmean(inorder{t, k}(1:Tasks(p2).dims)) = meanT{p2}(1:Tasks(p2).dims);
                        transfer{p1, p2} = alpha * (midnum - meanT{p1});
                        transfer{p2, p1} = alpha * (midnum - intmean);
                    end
                end
            end
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
