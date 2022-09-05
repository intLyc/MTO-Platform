classdef G_MFEA < Algorithm
    % <Multi> <None/Expensive>

    %------------------------------- Reference --------------------------------
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
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        rmp = 0.3
        mu = 2;
        mum = 5;
        phi = 0.1;
        theta = 0.02;
        top = 0.4;
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum), ...
                        'phi', num2str(obj.phi), ...
                        'theta', num2str(obj.theta), ...
                        'top', num2str(obj.top)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.rmp = str2double(Parameter{i}); i = i + 1;
            obj.mu = str2double(Parameter{i}); i = i + 1;
            obj.mum = str2double(Parameter{i}); i = i + 1;
            obj.phi = str2double(Parameter{i}); i = i + 1;
            obj.theta = str2double(Parameter{i}); i = i + 1;
            obj.top = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);

            % initialize
            [population, fnceval_calls, bestDec, bestObj] = initializeMF(IndividualG, pop_size, Tasks, max([Tasks.Dim]));
            convergeObj(:, 1) = bestObj;

            midnum = 0.5 * ones(1, max([Tasks.Dim]));
            alpha = 0;
            meanT = {};
            transfer = {};
            inorder = {};
            for t = 1:length(Tasks)
                meanT{t} = zeros(1, max([Tasks.Dim]));
            end
            for t = 1:length(Tasks)
                population_t = population([population.skill_factor] == t);
                pop_Dec{t} = reshape([population_t.Dec], length(population_t(1).Dec), length(population_t))';
                pop_fit{t} = [population_t.scalar_fitness];
            end
            for t = 1:length(Tasks) - 1
                for k = (t + 1):length(Tasks)
                    inorder{t, k} = randperm(max([Tasks.Dim]));
                    if Tasks(t).Dim > Tasks(k).Dim
                        p1 = t; p2 = k;
                    else
                        p1 = k; p2 = t;
                    end
                    index = randi(size(pop_Dec{p1}, 1), [size(pop_Dec{p2}, 1), 1]);
                    intpop = pop_Dec{p1}(index, :);
                    intpop(:, inorder{t, k}(1:Tasks(p2).Dim)) = pop_Dec{p2}(:, 1:Tasks(p2).Dim);
                    idx = 1;
                    for i = find([population.skill_factor] == p2)
                        population(i).Dec = intpop(idx, :);
                        idx = idx + 1;
                    end
                    transfer{t, k} = alpha * meanT{p1};
                    transfer{k, t} = alpha * meanT{p2};
                end
            end

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorMFEA_G.generate(population, Tasks, obj.rmp, obj.mu, obj.mum, transfer);
                fnceval_calls = fnceval_calls + calls;

                for t = 1:length(Tasks) - 1
                    for k = (t + 1):length(Tasks)
                        % p2.dim <= p1.dim
                        if Tasks(t).Dim > Tasks(k).Dim
                            p1 = t; p2 = k;
                        else
                            p1 = k; p2 = t;
                        end
                        for i = 1:length(population)
                            if population(i).skill_factor == p2
                                population(i).Dec(1:Tasks(p2).Dim) = population(i).Dec(inorder{t, k}(1:Tasks(p2).Dim));
                            end
                            if offspring(i).skill_factor == p2
                                offspring(i).Dec(1:Tasks(p2).Dim) = offspring(i).Dec(inorder{t, k}(1:Tasks(p2).Dim));
                            end
                        end
                        meanT{p2}(1:Tasks(p2).Dim) = meanT{p2}(inorder{t, k}(1:Tasks(p2).Dim));
                    end
                end

                % selection
                [population, bestDec, bestObj] = selectMF(population, offspring, Tasks, pop_size, bestDec, bestObj);
                convergeObj(:, generation) = bestObj;

                pop_Dec = {};
                pop_fit = {};
                for t = 1:length(Tasks)
                    population_t = population([population.skill_factor] == t);
                    pop_Dec{t} = reshape([population_t.Dec], length(population_t(1).Dec), length(population_t))';
                    pop_fit{t} = [population_t.scalar_fitness];
                end

                if generation >= obj.phi * (eva_num / pop_size) && mod(generation, round(obj.theta * (eva_num / pop_size))) == 0
                    alpha = (fnceval_calls / eva_num)^2;
                    for t = 1:length(Tasks)
                        [~, y] = sort(-pop_fit{t});
                        meanT{t} = mean(pop_Dec{t}(y(1:round(obj.top * pop_size / length(Tasks))), :));
                    end
                end

                for t = 1:length(Tasks) - 1
                    for k = (t + 1):length(Tasks)
                        inorder{t, k} = randperm(max([Tasks.Dim]));
                        if Tasks(t).Dim > Tasks(k).Dim
                            % p2.dim <= p1.dim
                            p1 = t; p2 = k;
                        else
                            p1 = k; p2 = t;
                        end
                        index = randi(size(pop_Dec{p1}, 1), [size(pop_Dec{p2}, 1), 1]);
                        intpop = pop_Dec{p1}(index, :);
                        intpop(:, inorder{t, k}(1:Tasks(p2).Dim)) = pop_Dec{p2}(:, 1:Tasks(p2).Dim);
                        idx = 1;
                        for i = find([population.skill_factor] == p2)
                            population(i).Dec = intpop(idx, :);
                            idx = idx + 1;
                        end
                        intmean = meanT{p1};
                        intmean(inorder{t, k}(1:Tasks(p2).Dim)) = meanT{p2}(1:Tasks(p2).Dim);
                        transfer{p1, p2} = alpha * (midnum - meanT{p1});
                        transfer{p2, p1} = alpha * (midnum - intmean);
                    end
                end
            end
            data.convergeObj = gen2eva(convergeObj);
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
