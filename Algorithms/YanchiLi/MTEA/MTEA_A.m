classdef MTEA_A < Algorithm

    properties (SetAccess = private)
        Tnum = 8
        Titer = [0, 1]
        operator_list = ["GA"]
        GA_mu = 10 % 模拟二进制交叉的染色体长度
        GA_pM = 0.1 % 变异概率
        GA_sigma = 0.02 % 高斯变异的标准差
        DE_F = 0.5
        DE_pCR = 0.9
    end

    methods

        function parameter = getParameter(obj)

            string_format = '%s';

            for o = 2:length(obj.operator_list)
                string_format = [string_format, '/%s'];
            end

            operator_string = sprintf(string_format, obj.operator_list);
            titer_string = sprintf('%d/%d', obj.Titer);

            parameter = {'Tnum: Transfer num per iter', num2str(obj.Tnum), ...
                        'Titer: No Transfer iter/Transfer iter', titer_string, ...
                        'Operator_list: GA/DE', operator_string, ...
                        'mu: GA SBX Crossover length', num2str(obj.GA_mu), ...
                        'pM: GA Mutation Probability', num2str(obj.GA_pM), ...
                        'sigma: GA Mutation Sigma', num2str(obj.GA_sigma), ...
                        'F: DE Mutation Factor', num2str(obj.DE_F), ...
                        'pCR: DE Crossover Probability', num2str(obj.DE_pCR)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.Tnum = str2num(parameter_cell{count}); count = count + 1;
            obj.Titer = str2num(char(split(parameter_cell{count}, '/'))); count = count + 1;
            obj.operator_list = string(split(parameter_cell{count}, '/')); count = count + 1;
            obj.GA_mu = str2num(parameter_cell{count}); count = count + 1;
            obj.GA_pM = str2num(parameter_cell{count}); count = count + 1;
            obj.GA_sigma = str2double(parameter_cell{count}); count = count + 1;
            obj.DE_F = str2double(parameter_cell{count}); count = count + 1;
            obj.DE_pCR = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, pre_run_list)
            obj.setPreRun(pre_run_list);
            tic
            archive_num = 2 * obj.pop_size; % 存档大小
            no_of_tasks = length(Tasks); % 任务数量

            %fix operator_list
            operator_list_input = obj.operator_list;

            for t = length(operator_list_input) + 1:no_of_tasks
                obj.operator_list(t) = operator_list_input(mod(t - 1, length(operator_list_input)) + 1);
            end

            % fix pop size
            if mod(obj.pop_size, no_of_tasks) ~= 0
                obj.pop_size = obj.pop_size + no_of_tasks - mod(obj.pop_size, no_of_tasks);
            end

            % fix Tnum
            if obj.Tnum >= ceil(obj.pop_size / no_of_tasks)
                obj.Tnum = ceil(obj.pop_size / no_of_tasks);
            end

            sub_pop = ceil(obj.pop_size / no_of_tasks);
            D = zeros(1, no_of_tasks); % 每个任务解的维数
            population = {};
            archive = {};
            TotalEvaluations = 0;
            bestobj = inf([1, no_of_tasks]);

            % initialize
            for t = 1:no_of_tasks
                D(t) = Tasks(t).dims;

                for i = 1:sub_pop
                    population{t}(i) = Chromosome_MTEA();
                    population{t}(i) = initialize(population{t}(i), D(t));
                    [population{t}(i), calls] = evaluate(population{t}(i), Tasks(t));
                    TotalEvaluations = TotalEvaluations + calls;
                end

                archive{t}(1:sub_pop) = population{t};
                [bestobj_iter, min_idx] = min([population{t}.fitness]);

                if bestobj_iter < bestobj(t)
                    bestobj(t) = bestobj_iter;
                    bestX(t) = population{t}(min_idx);
                end

                data.convergence(t, 1) = bestobj(t);
            end

            % main loop
            iter = 1;

            while iter < obj.iter_num && TotalEvaluations < obj.eva_num
                iter = iter + 1;

                % evolution
                for t = 1:no_of_tasks

                    switch obj.operator_list(t)
                        case 'GA'
                            child = obj.operator_GA(population{t}, D(t), obj.GA_mu, obj.GA_pM, obj.GA_sigma);
                        case 'DE'
                            child = obj.operator_DE(population{t}, obj.DE_F, obj.DE_pCR);
                    end

                    % Weak Transfer
                    if (mod((iter - 1), sum(obj.Titer)) + 1) - obj.Titer(1) > 0 && obj.Tnum > 0;
                        transfer_individuals = Transfer_Random([archive(1:t - 1), archive(t + 1:end)], bestX(t), obj.Tnum);
                        replace_idx = randperm(length(child));
                        child(replace_idx(1:obj.Tnum)) = transfer_individuals;
                    end

                    for i = 1:length(child)
                        [child(i), calls] = evaluate(child(i), Tasks(t));
                        TotalEvaluations = TotalEvaluations + calls;
                    end

                    % selection
                    intpopulation(1:length(population{t})) = population{t};
                    intpopulation(length(population{t}) + 1:length(population{t}) + length(child)) = child;
                    [~, y] = sort([intpopulation.fitness]);
                    intpopulation = intpopulation(y);
                    population{t} = intpopulation(1:sub_pop);
                    [bestobj_iter, min_idx] = min([population{t}.fitness]);

                    if bestobj_iter < bestobj(t)
                        bestobj(t) = bestobj_iter;
                        bestX(t) = population{t}(min_idx);
                    end

                    data.convergence(t, iter) = bestobj(t);
                end

                % update archive
                for t = 1:no_of_tasks

                    if length(archive{t}) < archive_num
                        need_num = min(archive_num - length(archive{t}), length(population{t}));
                        archive{t}(length(archive{t}) + 1:length(archive{t}) + need_num) = population{t}(1:need_num);
                    else
                        % 随机选取U(1,n/2)个个体更新archive
                        update_pop_idx = randperm(length(population{t}));
                        update_pop_idx = update_pop_idx(1:randi([1, fix(length(population{t}) / 2)]));
                        archive{t}(1:length(update_pop_idx)) = population{t}(update_pop_idx);
                        archive{t} = [archive{t}(length(update_pop_idx) + 1:end), archive{t}(1:length(update_pop_idx))];
                    end

                end

            end

            data.clock_time = toc;
        end

        function child = operator_GA(obj, population, D, mu, pM, sigma)
            indorder = randperm(length(population));
            count = 1;

            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                child(count) = Chromosome_MTEA();
                child(count + 1) = Chromosome_MTEA();
                u = rand(1, D);
                cf = zeros(1, D);
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
                child(count) = crossover(child(count), population(p1), population(p2), cf);
                child(count + 1) = crossover(child(count + 1), population(p2), population(p1), cf);

                if rand(1) < pM
                    child(count) = mutate(child(count), child(count), D, sigma);
                    child(count + 1) = mutate(child(count + 1), child(count + 1), D, sigma);
                end

                count = count + 2;
            end

        end

        function child = operator_DE(obj, population, F, pCR)

            for i = 1:length(population)
                x = population(i).rnvec; % 提取个体位置
                A = randperm(length(population));
                A(A == i) = []; % 当前个体所排位置腾空（产生变异中间体时当前个体不参与）
                p1 = A(1);
                p2 = A(mod(2 - 1, length(A)) + 1);
                p3 = A(mod(3 - 1, length(A)) + 1);
                % 变异操作 Mutation
                % beta=unifrnd(beta_min,beta_max,VarSize); % 随机产生缩放因子
                y = population(p1).rnvec + F * (population(p2).rnvec - population(p3).rnvec); % 产生中间体
                % 防止中间体越界
                lb = 0; % 参数取值下界
                ub = 1; % 参数取值上界
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

                child(i) = Chromosome_MTEA();
                child(i).rnvec = z;
            end

        end

    end

end
