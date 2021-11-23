classdef MFDE < Algorithm
    % @InProceedings{Feng2017MFDE-MFPSO,
    %     author    = {Feng, L. and Zhou, W. and Zhou, L. and Jiang, S. W. and Zhong, J. H. and Da, B. S. and Zhu, Z. X. and Wang, Y.},
    %     booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %     title     = {An empirical study of multifactorial PSO and multifactorial DE},
    %     year      = {2017},
    %     pages     = {921-928},
    %     doi       = {10.1109/CEC.2017.7969407},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        selection_process = 'elitist'
        p_il = 0
        F = 0.5
        pCR = 0.9
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        '("elitist"/"roulette wheel"): Selection Type', obj.selection_process, ...
                        'p_il: Local Search Probability', num2str(obj.p_il), ...
                        'F: Mutation Factor', num2str(obj.F), ...
                        'pCR: Crossover Probability', num2str(obj.pCR)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.selection_process = parameter_cell{count}; count = count + 1;
            obj.p_il = str2double(parameter_cell{count}); count = count + 1;
            obj.F = str2double(parameter_cell{count}); count = count + 1;
            obj.pCR = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop = run_parameter_list(1);
            gen = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            rmp = obj.rmp;
            selection_process = obj.selection_process;
            p_il = obj.p_il;
            F = obj.F;
            pCR = obj.pCR;

            tic

            no_of_tasks = length(Tasks);

            if mod(pop, no_of_tasks) ~= 0
                pop = pop + no_of_tasks - mod(pop, no_of_tasks);
            end

            if no_of_tasks <= 1
                error('At least 2 tasks required for MFDE');
            end

            D = zeros(1, no_of_tasks);

            for i = 1:no_of_tasks
                D(i) = Tasks(i).dims;
            end

            D_multitask = max(D);
            options = optimoptions(@fminunc, 'Display', 'off', 'Algorithm', 'quasi-newton', 'MaxIter', 2); % settings for individual learning

            fnceval_calls = zeros(1);
            calls_per_individual = zeros(1, pop);
            bestobj = Inf(1, no_of_tasks);
            bestFncErrorValue = zeros(100, 60);

            for i = 1:pop
                population(i) = Chromosome_MFDE();
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

            lb = zeros(1, D_multitask); % 参数取值下界
            ub = ones(1, D_multitask); % 参数取值上界
            generation = 1;

            while generation < gen && TotalEvaluations(generation) < eva_num
                generation = generation + 1;
                count = 1;

                group = cell([1, no_of_tasks]); % replace the 2 task MFDE asf and bsf

                for j = 1:pop
                    group{population(j).skill_factor} = [group{population(j).skill_factor}, j];
                end

                for i = 1:pop
                    x = population(i).rnvec; % 提取个体基因型

                    isf = population(i).skill_factor;

                    igroup = group{isf};
                    A = randperm(length(igroup));
                    igroup = igroup(A);

                    childsf = 0;

                    for j = 1:length(igroup)

                        if igroup(j) == i
                            igroup(j) = [];
                            break;
                        end

                    end

                    if ~isempty(igroup)
                        p1 = igroup(1);
                    else
                        p1 = other(1);
                    end

                    urmp = rand(1);

                    other = [];

                    for sf = 1:length(group)

                        if sf ~= isf
                            other = [other, group{sf}];
                        end

                    end

                    other = other(randperm(length(other)));

                    if urmp <= rmp
                        p2 = other(mod(2 - 1, length(other)) + 1);
                        p3 = other(mod(3 - 1, length(other)) + 1);
                        childsf = 1;
                    else

                        if ~isempty(igroup)
                            p2 = igroup(mod(2 - 1, length(igroup)) + 1);
                            p3 = igroup(mod(3 - 1, length(igroup)) + 1);
                        else
                            p2 = other(mod(2 - 1, length(other)) + 1);
                            p3 = other(mod(3 - 1, length(other)) + 1);
                        end

                    end

                    % 变异操作 Mutation
                    y = population(p1).rnvec + F * (population(p2).rnvec - population(p3).rnvec); % 产生中间体
                    % 防止中间体越界
                    y = max(y, lb);
                    y = min(y, ub);

                    z = zeros(size(x)); % 初始化一个新个体
                    j0 = randi([1, numel(x)]); % 产生一个伪随机数，即选取待交换维度编号

                    for j = 1:numel(x) % 遍历每个维度

                        if j == j0 || rand <= pCR % 如果当前维度是待交换维度或者随机概率小于交叉概率
                            z(j) = y(j); % 新个体当前维度值等于中间体对应维度值
                        else
                            z(j) = x(j); % 新个体当前维度值等于当前个体对应维度值
                        end

                    end

                    child(count) = Chromosome_MFDE();
                    child(count).rnvec = z;

                    if childsf == 0
                        child(count).skill_factor = population(i).skill_factor;
                    else
                        u = rand(1);
                        child(count).skill_factor(u <= 0.5) = population(i).skill_factor;
                        child(count).skill_factor(u > 0.5) = randi([1, no_of_tasks]);
                    end

                    count = count + 1;

                end

                for i = 1:pop
                    [child(i), calls_per_individual(i)] = evaluate(child(i), Tasks, p_il, no_of_tasks, options);
                end

                fnceval_calls = fnceval_calls + sum(calls_per_individual);
                TotalEvaluations(generation) = fnceval_calls;

                intpopulation(1:pop) = population;
                intpopulation(pop + 1:2 * pop) = child;
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

                    if intpopulation(1).factorial_costs(i) <= bestobj(i)
                        bestobj(i) = intpopulation(1).factorial_costs(i);
                        bestInd_data(i) = intpopulation(1);
                    end

                    EvBestFitness(i, generation) = bestobj(i);

                    if mod(fnceval_calls, 3000) == 0
                        bestFncErrorValue(fnceval_calls / 3000, 1) = fnceval_calls;
                        bestFncErrorValue(fnceval_calls / 3000, i + 1) = bestobj(i);
                    end

                end

                for i = 1:2 * pop
                    [xxx, yyy] = min(intpopulation(i).factorial_ranks);
                    intpopulation(i).skill_factor = yyy;
                    intpopulation(i).scalar_fitness = 1 / xxx;
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

                % disp(['MFDE Generation = ', num2str(generation), ' best factorial costs = ', num2str(bestobj)]);
            end

            data.clock_time = toc; % 计时结束
            data.convergence = EvBestFitness;
        end

        % dlmwrite(['MTSOO_P', num2str(index), '.txt'], bestFncErrorValue, 'precision', 6);
    end

end
