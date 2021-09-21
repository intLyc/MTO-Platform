classdef MFEA < Algorithm

    properties (SetAccess = private)
        rmp = 0.3
        selection_process = 'elitist'
        p_il = 0
        mu = 10 % 模拟二进制交叉的染色体长度
        sigma = 0.02 % 高斯变异的标准差
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'Random Mating Probability (rmp)', num2str(obj.rmp), ...
                        'elitist / roulette wheel', obj.selection_process, ...
                        'Local Search Probability (p_il)', num2str(obj.p_il), ...
                        'SBX Crossover length (mu)', num2str(obj.mu), ...
                        'Mutation Sigma (sigma)', num2str(obj.sigma)};
        end

        function obj = setParameter(obj, parameter_cell)
            obj.rmp = str2double(parameter_cell{1});
            obj.selection_process = parameter_cell{2};
            obj.p_il = str2double(parameter_cell{3});
            obj.mu = str2num(parameter_cell{4});
            obj.sigma = str2double(parameter_cell{5});
        end

        function data = run(obj, Tasks, pre_run_list)
            obj.setPreRun(pre_run_list);
            rmp = obj.rmp;
            pop = obj.pop_size;
            gen = obj.iter_num;
            eva_num = obj.eva_num;
            selection_process = obj.selection_process;
            p_il = obj.p_il;
            mu = obj.mu;
            sigma = obj.sigma;

            tic % 计时开始

            % 保证种群数量为2的整数倍
            if mod(pop, 2) ~= 0
                pop = pop + 1;
            end

            no_of_tasks = length(Tasks); % 任务数量

            % 保证任务数量大于1
            if no_of_tasks <= 1
                error('At least 2 tasks required for MFEA');
            end

            D = zeros(1, no_of_tasks); % 每个任务解的维数

            for i = 1:no_of_tasks
                D(i) = Tasks(i).dims;
            end

            D_multitask = max(D); %个体的维数(所有任务中最大的维数)

            % 局部搜索方法，quasi-newton法
            options = optimoptions(@fminunc, 'Display', 'off', 'Algorithm', 'quasi-newton', 'MaxIter', 5);

            fnceval_calls = zeros(1); % 总评价次数
            calls_per_individual = zeros(1, pop); % 每个个体的评价次数
            bestobj = inf * (ones(1, no_of_tasks)); % 每个任务的最优解

            % 生成种群
            for i = 1:pop
                population(i) = Chromosome_MFEA();
                population(i) = initialize(population(i), D_multitask);
                population(i).skill_factor = 0;
            end

            % 适应值评价
            for i = 1:pop
                [population(i), calls_per_individual(i)] = evaluate(population(i), Tasks, p_il, no_of_tasks, options);
            end

            % 更新评价次数
            fnceval_calls = fnceval_calls + sum(calls_per_individual);
            TotalEvaluations(1) = fnceval_calls;

            factorial_cost = zeros(1, pop); % 每个个体的因子函数值

            for i = 1:no_of_tasks
                % 统计个体在每个任务上的因子排名

                for j = 1:pop
                    factorial_cost(j) = population(j).factorial_costs(i);
                end

                % 按照任务i的函数值对population进行排序
                [~, y] = sort(factorial_cost);
                population = population(y);

                for j = 1:pop
                    % 统计每个个体在第i个任务的排名
                    population(j).factorial_ranks(i) = j;
                end

                bestobj(i) = population(1).factorial_costs(i);
                EvBestFitness(i, 1) = bestobj(i);
            end

            for i = 1:pop
                % 设置每个个体的技能因子

                % 找到每个个体最适应的任务
                [xxx, yyy] = min(population(i).factorial_ranks);
                x = find(population(i).factorial_ranks == xxx);
                equivalent_skills = length(x); % 最适应的任务的个数

                if equivalent_skills > 1
                    % 适应多个任务

                    % 随机选取一个最适应的任务
                    population(i).skill_factor = x(1 + round((equivalent_skills - 1) * rand(1)));
                    % 将其他的函数值置为无穷大，只保留当前最适应的任务的函数值
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
                indorder = randperm(pop); % 随机排列
                count = 1;

                for i = 1:pop / 2
                    % 选取双亲生成子代
                    p1 = indorder(i);
                    p2 = indorder(i + (pop / 2));
                    child(count) = Chromosome_MFEA();
                    child(count + 1) = Chromosome_MFEA();

                    if (population(p1).skill_factor == population(p2).skill_factor) || (rand(1) < rmp)
                        % 双亲技能因子相同，或小于rmp随机匹配概率，进行交叉
                        % 对浮点数进行模拟二进制单点交叉
                        u = rand(1, D_multitask);
                        cf = zeros(1, D_multitask); % 每个基因的交叉点
                        cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                        cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
                        child(count) = crossover(child(count), population(p1), population(p2), cf);
                        child(count + 1) = crossover(child(count + 1), population(p2), population(p1), cf);

                        % 随机遗传双亲的技能因子
                        sf1 = 1 + round(rand(1));
                        sf2 = 1 + round(rand(1));

                        if sf1 == 1
                            child(count).skill_factor = population(p1).skill_factor;
                        else
                            child(count).skill_factor = population(p2).skill_factor;
                        end

                        if sf2 == 1
                            child(count + 1).skill_factor = population(p1).skill_factor;
                        else
                            child(count + 1).skill_factor = population(p2).skill_factor;
                        end

                        % % 两个孩子的变量随机交换(alpha版本没有)
                        % swap_indicator = (rand(1, D_multitask) >= 0.5);
                        % temp = child(count + 1).rnvec(swap_indicator);
                        % child(count + 1).rnvec(swap_indicator) = child(count).rnvec(swap_indicator);
                        % child(count).rnvec(swap_indicator) = temp;
                    else
                        % 变异
                        child(count) = mutate(child(count), population(p1), D_multitask, sigma);
                        child(count).skill_factor = population(p1).skill_factor;
                        child(count + 1) = mutate(child(count + 1), population(p2), D_multitask, sigma);
                        child(count + 1).skill_factor = population(p2).skill_factor;
                    end

                    count = count + 2;
                end

                for i = 1:pop
                    % 函数值评价
                    [child(i), calls_per_individual(i)] = evaluate(child(i), Tasks, p_il, no_of_tasks, options);
                end

                % 更新评价次数
                fnceval_calls = fnceval_calls + sum(calls_per_individual);
                TotalEvaluations(generation) = fnceval_calls;

                % 合并两代种群
                intpopulation(1:pop) = population;
                intpopulation(pop + 1:2 * pop) = child;
                factorial_cost = zeros(1, 2 * pop);

                for i = 1:no_of_tasks
                    % 统计个体在每个任务上的因子排名

                    for j = 1:2 * pop
                        factorial_cost(j) = intpopulation(j).factorial_costs(i);
                    end

                    % 按照任务i的函数值对population进行排序
                    [~, y] = sort(factorial_cost);
                    intpopulation = intpopulation(y);

                    for j = 1:2 * pop
                        % 统计每个个体在第i个任务的排名
                        intpopulation(j).factorial_ranks(i) = j;
                    end

                    % 更新每个任务的最优解和最优个体
                    if intpopulation(1).factorial_costs(i) <= bestobj(i)
                        bestobj(i) = intpopulation(1).factorial_costs(i);
                    end

                    EvBestFitness(i, generation) = bestobj(i);
                end

                for i = 1:2 * pop
                    % 更新每个个体的技能因子和标量适应值
                    [xxx, yyy] = min(intpopulation(i).factorial_ranks);
                    intpopulation(i).skill_factor = yyy;
                    intpopulation(i).scalar_fitness = 1 / xxx;
                end

                if strcmp(selection_process, 'elitist')
                    % 保留适应值最好的前pop个
                    [xxx, y] = sort(-[intpopulation.scalar_fitness]);
                    intpopulation = intpopulation(y);
                    population = intpopulation(1:pop);
                elseif strcmp(selection_process, 'roulette wheel')
                    % 轮盘赌选择
                    for i = 1:no_of_tasks
                        % 每个任务对应的个体分别成组
                        skill_group(i).individuals = intpopulation([intpopulation.skill_factor] == i);
                    end

                    count = 0;

                    while count < pop
                        count = count + 1;
                        % 每个任务循环选取个体
                        skill = mod(count, no_of_tasks) + 1;
                        population(count) = skill_group(skill).individuals(RouletteWheelSelection([skill_group(skill).individuals.scalar_fitness]));
                    end

                end

                % disp(['MFEA Generation = ', num2str(generation), ' best factorial costs = ', num2str(bestobj)]);
            end

            data.clock_time = toc; % 计时结束
            data.convergence = EvBestFitness;
        end

    end

end
