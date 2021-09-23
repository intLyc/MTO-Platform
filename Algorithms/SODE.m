classdef SODE < Algorithm

    properties (SetAccess = private)
        selection_process = 'elitist'
        p_il = 0
        F = 0.5
        pCR = 0.9
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'elitist / roulette wheel', obj.selection_process, ...
                        'Local Search Probability (p_il)', num2str(obj.p_il), ...
                        'Mutation Factor (F)', num2str(obj.F), ...
                        'Crossover Probability (pCR)', num2str(obj.pCR)};
        end

        function obj = setParameter(obj, parameter_cell)
            obj.selection_process = parameter_cell{1};
            obj.p_il = str2double(parameter_cell{2});
            obj.F = str2double(parameter_cell{3});
            obj.pCR = str2double(parameter_cell{4})
        end

        function data = run(obj, Tasks, pre_run_list)
            obj.setPreRun(pre_run_list);
            pop = obj.pop_size;
            gen = obj.iter_num;
            eva_num = obj.eva_num;
            selection_process = obj.selection_process;
            p_il = obj.p_il;
            F = obj.F;
            pCR = obj.pCR;
            data.convergence = [];

            tic

            no_of_tasks = length(Tasks); % 任务数量

            if mod(pop, no_of_tasks) ~= 0
                pop = pop + no_of_tasks - mod(pop, no_of_tasks);
            end

            sub_pop = int32(pop / no_of_tasks);

            for sub_task = 1:no_of_tasks
                Task = Tasks(sub_task);

                D = Task.dims;
                options = optimoptions(@fminunc, 'Display', 'off', 'Algorithm', 'quasi-newton', 'MaxIter', 5);

                fnceval_calls = 0;
                calls_per_individual = zeros(1, sub_pop);
                % EvBestFitness = zeros(1, gen);
                % TotalEvaluations = zeros(1, gen);

                for i = 1:sub_pop
                    population(i) = Chromosome_MFDE();
                    population(i) = initialize(population(i), D);
                end

                for i = 1:sub_pop
                    [population(i), calls_per_individual(i)] = evaluate_SOO(population(i), Task, p_il, options);
                end

                fnceval_calls = fnceval_calls + sum(calls_per_individual);
                TotalEvaluations(1) = fnceval_calls;
                bestobj = min([population.factorial_costs]);
                EvBestFitness(1) = bestobj;

                %         VarSize=[1 D];   % Decision Variables Matrix Size
                %         beta_min=0.2;   % Lower Bound of Scaling Factor
                %         beta_max=0.8;   % Upper Bound of Scaling Factor
                lb = zeros(1, D); % 参数取值下界
                ub = ones(1, D); % 参数取值上界
                generation = 1;

                while generation < gen && TotalEvaluations(generation) < int32(eva_num / no_of_tasks)
                    generation = generation + 1;
                    count = 1;

                    for i = 1:sub_pop
                        x = population(i).rnvec; % 提取个体位置
                        A = randperm(sub_pop);

                        A(A == i) = []; % 当前个体所排位置腾空（产生变异中间体时当前个体不参与）
                        p1 = A(1);
                        p2 = A(2);
                        p3 = A(3);
                        % 变异操作 Mutation
                        %                 beta=unifrnd(beta_min,beta_max,VarSize); % 随机产生缩放因子
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

                        count = count + 1;
                    end

                    for i = 1:sub_pop
                        [child(i), calls_per_individual(i)] = evaluate_SOO(child(i), Task, p_il, options);
                    end

                    fnceval_calls = fnceval_calls + sum(calls_per_individual);
                    TotalEvaluations(generation) = fnceval_calls;

                    intpopulation(1:sub_pop) = population;
                    intpopulation(sub_pop + 1:2 * sub_pop) = child;
                    [xxx, y] = sort([intpopulation.factorial_costs]);
                    intpopulation = intpopulation(y);

                    for i = 1:2 * sub_pop
                        intpopulation(i).scalar_fitness = 1 / i;
                    end

                    if intpopulation(1).factorial_costs <= bestobj
                        bestobj = intpopulation(1).factorial_costs;
                        bestInd_data = intpopulation(1);
                    end

                    EvBestFitness(generation) = bestobj;

                    if strcmp(selection_process, 'elitist')
                        [xxx, y] = sort(-[intpopulation.scalar_fitness]);
                        intpopulation = intpopulation(y);
                        population = intpopulation(1:sub_pop);
                    elseif strcmp(selection_process, 'roulette wheel')

                        for i = 1:sub_pop
                            population(i) = intpopulation(RouletteWheelSelection([intpopulation.scalar_fitness]));
                        end

                    end

                    % disp(['SOO Generation ', num2str(generation), ' best objective = ', num2str(bestobj)])
                end

                data.convergence = [data.convergence; EvBestFitness];
            end

            data.clock_time = toc;

        end

    end

end
