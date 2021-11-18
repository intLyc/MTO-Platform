classdef MFEA_AKT < Algorithm
    % @Article{zhou2020MFEA-AKT,
    %     author     = {Zhou, Lei and Feng, Liang and Tan, Kay Chen and Zhong, Jinghui and Zhu, Zexuan and Liu, Kai and Chen, Chao},
    %     journal    = {IEEE transactions on cybernetics},
    %     title      = {Toward adaptive knowledge transfer in multifactorial evolutionary computation},
    %     year       = {2020},
    %     number     = {5},
    %     pages      = {2563--2576},
    %     volume     = {51},
    %     publisher  = {IEEE},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        selection_process = 'elitist'
        p_il = 0;
        mu = 2; % index of Simulated Binary Crossover (tunable)
        mum = 5; % index of polynomial mutation
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        '("elitist"/"roulette wheel"): Selection Type', obj.selection_process, ...
                        'p_il: Local Search Probability', num2str(obj.p_il), ...
                        'mu: SBX Crossover Length', num2str(obj.mu), ...
                        'mum: Ploy Mutation length', num2str(obj.mum)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.selection_process = parameter_cell{count}; count = count + 1;
            obj.p_il = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2num(parameter_cell{count}); count = count + 1;
            obj.mum = str2num(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop = run_parameter_list(1);
            gen = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            rmp = obj.rmp;
            selection_process = obj.selection_process;
            p_il = obj.p_il;
            mu = obj.mu;
            mum = obj.mum;

            tic

            ncx = 8; % AKT

            no_of_tasks = length(Tasks);

            if mod(pop, no_of_tasks) ~= 0
                pop = pop + no_of_tasks - mod(pop, no_of_tasks);
            end

            if no_of_tasks <= 1
                error('At least 2 tasks required for MFEA');
            end

            D = zeros(1, no_of_tasks);

            for i = 1:no_of_tasks
                D(i) = Tasks(i).dims;
            end

            D_multitask = max(D);
            options = optimoptions(@fminunc, 'Display', 'off', 'Algorithm', 'quasi-newton', 'MaxIter', 2); % settings for individual learning

            ginterval = 20;

            fnceval_calls = zeros(1);
            calls_per_individual = zeros(1, pop);
            bestobj = Inf(1, no_of_tasks);

            % cfbRecord = zeros(gen, 1);
            % cfRecord = zeros(gen, 6);

            for i = 1:pop
                population(i) = Chromosome_MFEA_AKT();
                population(i) = initialize(population(i), D_multitask);
                population(i).skill_factor = 0;
            end

            for i = 1:pop
                [population(i), calls_per_individual(i)] = evaluate(population(i), Tasks, p_il, no_of_tasks, options);
            end

            fnceval_calls = fnceval_calls + sum(calls_per_individual);
            TotalEvaluations(1) = fnceval_calls;

            factorial_cost = zeros(1, pop);

            for i = 1:no_of_tasks

                for j = 1:pop
                    factorial_cost(j) = population(j).factorial_costs(i);
                end

                [xxx, y] = sort(factorial_cost);
                population = population(y);

                for j = 1:pop
                    population(j).factorial_ranks(i) = j;
                end

                bestobj(i) = population(1).factorial_costs(i);
                EvBestFitness(i, 1) = bestobj(i);
                bestInd_data(i) = population(1);
            end

            for i = 1:pop
                [xxx, yyy] = min(population(i).factorial_ranks);
                x = find(population(i).factorial_ranks == xxx);
                equivalent_skills = length(x);

                if equivalent_skills > 1
                    population(i).skill_factor = x(1 + round((equivalent_skills - 1) * rand(1)));
                    tmp = population(i).factorial_costs(population(i).skill_factor);
                    population(i).factorial_costs(1:no_of_tasks) = inf;
                    population(i).factorial_costs(population(i).skill_factor) = tmp;
                else
                    population(i).skill_factor = yyy;
                    tmp = population(i).factorial_costs(population(i).skill_factor);
                    population(i).factorial_costs(1:no_of_tasks) = inf;
                    population(i).factorial_costs(population(i).skill_factor) = tmp;
                end

            end

            generation = 1;

            while generation < gen && TotalEvaluations(generation) < eva_num
                generation = generation + 1;

                indorder = randperm(pop);
                count = 1;

                for i = 1:ceil(pop / 2)
                    p1 = indorder(i);
                    p2 = indorder(i + (floor(pop / 2)));
                    child(count) = Chromosome_MFEA_AKT();
                    child(count + 1) = Chromosome_MFEA_AKT();

                    if (population(p1).skill_factor == population(p2).skill_factor) || (rand(1) < rmp) % crossover
                        u = rand(1, D_multitask);
                        cf = zeros(1, D_multitask);
                        cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                        cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                        if population(p1).skill_factor == population(p2).skill_factor
                            child(count) = crossover(child(count), population(p1), population(p2), cf);
                            child(count + 1) = crossover(child(count + 1), population(p2), population(p1), cf);
                            % 交叉算子初始化
                            child(count).cx_factor = population(p1).cx_factor;
                            child(count + 1).cx_factor = population(p2).cx_factor;
                            child(count).isTran = 0;
                            child(count + 1).isTran = 0;
                        else
                            % 不同文化间杂交
                            switch ncx
                                case 1
                                    child(count) = spcrossover(child(count), population(p1), population(p2));
                                    child(count + 1) = spcrossover(child(count + 1), population(p2), population(p1));
                                case 2
                                    child(count) = tpcrossover(child(count), population(p1), population(p2));
                                    child(count + 1) = tpcrossover(child(count + 1), population(p2), population(p1));
                                case 3
                                    child(count) = ufcrossover(child(count), population(p1), population(p2));
                                    child(count + 1) = ufcrossover(child(count + 1), population(p2), population(p1));
                                case 4
                                    child(count) = aricrossover(child(count), population(p1), population(p2));
                                    child(count + 1) = aricrossover(child(count + 1), population(p2), population(p1));
                                case 5
                                    a = 0.3;
                                    child(count) = blxacrossover(child(count), population(p1), population(p2), a);
                                    child(count + 1) = blxacrossover(child(count + 1), population(p2), population(p1), a);
                                case 6
                                    child(count) = crossover(child(count), population(p1), population(p2), cf);
                                    child(count + 1) = crossover(child(count + 1), population(p2), population(p1), cf);
                                case 7
                                    child(count) = geocrossover(child(count), population(p1), population(p2));
                                    child(count + 1) = geocrossover(child(count + 1), population(p2), population(p1));
                                case 8
                                    % adpt
                                    if rand(1) < 0.5
                                        alpha = population(p1).cx_factor;
                                    else
                                        alpha = population(p2).cx_factor;
                                    end

                                    % cfRecord(generation, alpha) = cfRecord(generation, alpha) + 1;

                                    child(count) = hyberCX(child(count), population(p1), population(p2), cf, alpha);
                                    child(count + 1) = hyberCX(child(count + 1), population(p2), population(p1), cf, alpha);
                                    child(count).cx_factor = alpha;
                                    child(count + 1).cx_factor = alpha;
                                    child(count).isTran = 1;
                                    child(count + 1).isTran = 1;
                            end

                        end

                        if rand(1) < 1
                            child(count) = mutate(child(count), child(count), D_multitask, mum);
                            child(count + 1) = mutate(child(count + 1), child(count + 1), D_multitask, mum);
                        end

                        sf1 = 1 + round(rand(1));
                        sf2 = 1 + round(rand(1));

                        if sf1 == 1 % skill factor selection
                            child(count).skill_factor = population(p1).skill_factor;

                            if child(count).isTran == 1
                                child(count).parNum = p1;
                            end

                        else
                            child(count).skill_factor = population(p2).skill_factor;

                            if child(count).isTran == 1
                                child(count).parNum = p2;
                            end

                        end

                        if sf2 == 1
                            child(count + 1).skill_factor = population(p1).skill_factor;

                            if child(count + 1).isTran == 1
                                child(count + 1).parNum = p1;
                            end

                        else
                            child(count + 1).skill_factor = population(p2).skill_factor;

                            if child(count + 1).isTran == 1
                                child(count + 1).parNum = p2;
                            end

                        end

                    else
                        % mutate
                        child(count) = mutate(child(count), population(p1), D_multitask, mum);
                        child(count).skill_factor = population(p1).skill_factor;
                        child(count).cx_factor = population(p1).cx_factor;
                        child(count + 1) = mutate(child(count + 1), population(p2), D_multitask, mum);
                        child(count + 1).skill_factor = population(p2).skill_factor;
                        child(count + 1).cx_factor = population(p2).cx_factor;
                        child(count).isTran = 0;
                        child(count + 1).isTran = 0;
                    end

                    count = count + 2;
                end

                impNum = zeros(1, 6);

                for i = 1:pop
                    [child(i), calls_per_individual(i)] = evaluate(child(i), Tasks, p_il, no_of_tasks, options);

                    % 在子种群中统计最佳交叉因子
                    if child(i).parNum ~= 0
                        cfc = child(i).factorial_costs(child(i).skill_factor);
                        pfc = population(child(i).parNum).factorial_costs(population(child(i).parNum).skill_factor);

                        if (pfc - cfc) / pfc > impNum(child(i).cx_factor)
                            impNum(child(i).cx_factor) = (pfc - cfc) / pfc;
                        end

                    end

                end

                prCfb_Count = zeros(1, 6);

                if any(impNum)
                    [maxNum, maxInd] = max(impNum);
                else
                    % 没有更好的迁移交叉因子
                    if generation <= ginterval + 1
                        % 靠前的代数
                        for i = 2:generation - 1
                            prCfb_Count(cfbRecord(i)) = prCfb_Count(cfbRecord(i)) + 1;
                        end

                    else

                        for i = generation - ginterval:generation - 1
                            prCfb_Count(cfbRecord(i)) = prCfb_Count(cfbRecord(i)) + 1;
                        end

                    end

                    [maxNum, maxInd] = max(prCfb_Count);
                end

                cfbRecord(generation) = maxInd;

                % 交叉因子自适应
                for i = 1:pop

                    if child(i).parNum ~= 0
                        cfc = child(i).factorial_costs(child(i).skill_factor);
                        pfc = population(child(i).parNum).factorial_costs(population(child(i).parNum).skill_factor);

                        if (pfc - cfc) / pfc < 0
                            child(i).cx_factor = maxInd;
                        end

                    else

                        if rand() < 0.5
                            child(i).cx_factor = maxInd;
                        else
                            child(i).cx_factor = randi(6);
                        end

                    end

                end

                fnceval_calls = fnceval_calls + sum(calls_per_individual);
                TotalEvaluations(generation) = fnceval_calls;

                intpopulation(1:pop) = population;
                intpopulation(pop + 1:2 * pop) = child(1:pop);
                factorial_cost = zeros(1, 2 * pop);

                for i = 1:no_of_tasks

                    for j = 1:2 * pop
                        factorial_cost(j) = intpopulation(j).factorial_costs(i);
                    end

                    [xxx, y] = sort(factorial_cost);
                    intpopulation = intpopulation(y);

                    for j = 1:2 * pop
                        intpopulation(j).factorial_ranks(i) = j;
                    end

                    if intpopulation(1).factorial_costs(i) < bestobj(i)
                        bestobj(i) = intpopulation(1).factorial_costs(i);
                        bestInd_data(i) = intpopulation(1);
                    end

                    EvBestFitness(i, generation) = bestobj(i);
                end

                for i = 1:2 * pop
                    [xxx, yyy] = min(intpopulation(i).factorial_ranks);
                    intpopulation(i).skill_factor = yyy;
                    intpopulation(i).scalar_fitness = 1 / xxx;
                    intpopulation(i).isTran = 0;
                    intpopulation(i).parNum = 0;
                end

                if strcmp(selection_process, 'elitist')
                    [xxx, y] = sort(- [intpopulation.scalar_fitness]);
                    intpopulation = intpopulation(y);
                    population = intpopulation(1:pop);
                elseif strcmp(selection_process, 'roulette wheel')

                    for i = 1:no_of_tasks
                        skill_group(i).individuals = intpopulation([intpopulation.skill_factor] == i);
                    end

                    count = 0;

                    while count < pop
                        count = count + 1;
                        skill = mod(count, no_of_tasks) + 1;
                        population(count) = skill_group(skill).individuals(RouletteWheelSelection([skill_group(skill).individuals.scalar_fitness]));
                    end

                end

            end

            data.clock_time = toc; % 计时结束
            data.convergence = EvBestFitness;

        end

    end

end
