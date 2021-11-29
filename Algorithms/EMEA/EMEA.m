classdef EMEA < Algorithm
    % @Article{feng2018EMEA,
    %     author     = {Feng, Liang and Zhou, Lei and Zhong, Jinghui and Gupta, Abhishek and Ong, Yew-Soon and Tan, Kay-Chen and Qin, Alex Kai},
    %     journal    = {IEEE transactions on cybernetics},
    %     title      = {Evolutionary multitasking via explicit autoencoding},
    %     year       = {2018},
    %     number     = {9},
    %     pages      = {3457--3470},
    %     volume     = {49},
    %     publisher  = {IEEE},
    % }

    properties (SetAccess = private)
        Op = 'GA/DE';
        Snum = 10;
        Gap = 10;
        GA_mu = 2; % index of Simulated Binary Crossover (tunable)
        GA_mum = 5; % index of polynomial mutation
        DE_F = 0.5;
        DE_pCR = 0.6;
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'Op: Operator (Split with /)', obj.Op, ...
                        'S: Transfer num', num2str(obj.Snum), ...
                        'G: Transfer Gap', num2str(obj.Gap), ...
                        'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.GA_mu), ...
                        'mum: index of polynomial mutation', num2str(obj.GA_mum), ...
                        'F: DE Mutation Factor', num2str(obj.DE_F), ...
                        'pCR: DE Crossover Probability', num2str(obj.DE_pCR)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.Op = parameter_cell{count}; count = count + 1;
            obj.Snum = str2num(parameter_cell{count}); count = count + 1;
            obj.Gap = str2num(parameter_cell{count}); count = count + 1;
            obj.GA_mu = str2num(parameter_cell{count}); count = count + 1;
            obj.GA_mum = str2double(parameter_cell{count}); count = count + 1;
            obj.DE_F = str2double(parameter_cell{count}); count = count + 1;
            obj.DE_pCR = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop = run_parameter_list(1);
            gen = run_parameter_list(2);
            eva_num = run_parameter_list(3);

            % get operator
            op_list = split(obj.Op, '/');

            tic
            no_of_tasks = length(Tasks); % 任务数量

            % fix pop size
            if mod(pop, no_of_tasks) ~= 0
                pop = pop + no_of_tasks - mod(pop, no_of_tasks);
            end

            sub_pop = ceil(pop / no_of_tasks);
            D = zeros(1, no_of_tasks);
            population = {};
            TotalEvaluations = 0;
            bestobj = inf([1, no_of_tasks]);

            % initialize
            for t = 1:no_of_tasks
                D(t) = Tasks(t).dims;

                for i = 1:sub_pop
                    population{t}(i) = Chromosome_EMEA();
                    population{t}(i) = initialize(population{t}(i), D(t));
                    [population{t}(i), calls] = evaluate(population{t}(i), Tasks(t));
                    TotalEvaluations = TotalEvaluations + calls;
                end

                [bestobj_iter, min_idx] = min([population{t}.fitness]);

                if bestobj_iter < bestobj(t)
                    bestobj(t) = bestobj_iter;
                    bestX(t) = population{t}(min_idx);
                end

                data.convergence(t, 1) = bestobj(t);
            end

            % main loop
            iter = 1;

            while iter < gen && TotalEvaluations < eva_num
                iter = iter + 1;

                % evolution
                for t = 1:no_of_tasks
                    parent = population{t};

                    op_idx = mod(t - 1, length(op_list)) + 1;
                    op = op_list{op_idx};

                    switch op
                        case 'GA'
                            child = obj.operator_GA(parent, D(t), obj.GA_mu, obj.GA_mum);
                        case 'DE'
                            child = obj.operator_DE(parent, obj.DE_F, obj.DE_pCR);
                    end

                    % Direct Transfer
                    if obj.Snum > 0 && mod(iter, obj.Gap) == 0
                        inject_num = round(obj.Snum ./ (no_of_tasks - 1));
                        inject_pop = Chromosome_EMEA.empty();
                        for tt = 1:no_of_tasks
                            if t == tt
                                continue;
                            end
                            curr_pop = reshape([population{t}.rnvec], length(population{t}), length(population{t}(1).rnvec));
                            his_pop = reshape([population{tt}.rnvec], length(population{tt}), length(population{tt}(1).rnvec));
                            [~, his_best_idx] = sort([population{tt}.fitness]);
                            his_best = population{tt}(his_best_idx(1:inject_num));
                            his_best = reshape([his_best.rnvec], length(his_best), length(his_best(1).rnvec));
                            % curr
                            minrange = Tasks(t).Lb(1:Tasks(t).dims);
                            maxrange = Tasks(t).Ub(1:Tasks(t).dims);
                            y = maxrange - minrange;
                            curr_pop = y .* curr_pop + minrange;
                            % his
                            minrange = Tasks(tt).Lb(1:Tasks(tt).dims);
                            maxrange = Tasks(tt).Ub(1:Tasks(tt).dims);
                            y = maxrange - minrange;
                            his_pop = y .* his_pop + minrange;

                            inject = mDA(curr_pop, his_pop, his_best);

                            % map to [0,1]
                            minrange = Tasks(t).Lb(1:Tasks(t).dims);
                            maxrange = Tasks(t).Ub(1:Tasks(t).dims);
                            y = maxrange - minrange;
                            inject = (inject - minrange) ./ y;

                            % change to chromosome
                            for i = 1:size(inject, 1)
                                c = Chromosome_EMEA();
                                c.rnvec = inject(i, :);
                                c.rnvec(c.rnvec < 0) = 0;
                                c.rnvec(c.rnvec > 1) = 1;
                                inject_pop = [inject_pop, c];
                            end
                        end
                        replace_idx = randperm(length(child), length(inject_pop));
                        child(replace_idx) = inject_pop;
                        % child = [child, inject_pop];
                    end

                    for i = 1:length(child)
                        [child(i), calls] = evaluate(child(i), Tasks(t));
                        TotalEvaluations = TotalEvaluations + calls;
                    end

                    % selection
                    intpopulation = Chromosome_EMEA.empty();
                    intpopulation(1:length(population{t})) = population{t};
                    intpopulation(length(population{t}) + 1:length(population{t}) + length(child)) = child;
                    [~, y] = sort([intpopulation.fitness]);
                    intpopulation = intpopulation(y);
                    population{t} = intpopulation(1:length(population{t}));

                    [bestobj_iter, min_idx] = min([population{t}.fitness]);
                    if bestobj_iter < bestobj(t)
                        bestobj(t) = bestobj_iter;
                        bestX(t) = population{t}(min_idx);
                    end
                    data.convergence(t, iter) = bestobj(t);
                end
            end
            data.clock_time = toc;
        end

        function child = operator_GA(obj, population, D, mu, mum)

            if length(population) < 2
                child = population;
                return;
            end

            indorder = randperm(length(population));
            count = 1;

            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                child(count) = Chromosome_EMEA();
                child(count + 1) = Chromosome_EMEA();
                u = rand(1, D);
                cf = zeros(1, D);
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
                child(count) = crossover(child(count), population(p1), population(p2), cf);
                child(count + 1) = crossover(child(count + 1), population(p2), population(p1), cf);

                if rand(1) < 1
                    child(count) = mutate(child(count), child(count), D, mum);
                    child(count + 1) = mutate(child(count + 1), child(count + 1), D, mum);
                end

                count = count + 2;
            end

        end

        function child = operator_DE(obj, population, F, pCR)

            if length(population) < 2
                child = population;
                return;
            end

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

                child(i) = Chromosome_EMEA();
                child(i).rnvec = z;
            end

        end
    end
end
