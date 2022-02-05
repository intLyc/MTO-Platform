classdef MaTDE < Algorithm
    % @article{Chen2020MaTDE,
    %   author     = {Chen, Yongliang and Zhong, Jinghui and Feng, Liang and Zhang, Jun},
    %   journal    = {IEEE Transactions on Emerging Topics in Computational Intelligence},
    %   title      = {An Adaptive Archive-Based Evolutionary Framework for Many-Task Optimization},
    %   year       = {2020},
    %   number     = {3},
    %   pages      = {369-384},
    %   volume     = {4},
    %   doi        = {10.1109/TETCI.2019.2916051},
    % }

    properties (SetAccess = private)
        alpha = 0.1;
        replace_rate = 0.2;
        shrink_rate = 0.8;
        ro = 0.8;
        archive_multiplier = 3;
        LF = 0.1;
        UF = 2;
        LCR = 0.1;
        UCR = 0.9;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'alpha: Knowledge Transfer Rate', num2str(obj.alpha), ...
                        'replace_rate: Archive Update Rate', num2str(obj.replace_rate), ...
                        'shrink_rate: Reward Shrink Rate', num2str(obj.shrink_rate), ...
                        'ro: Attenuation Coefficient', num2str(obj.ro), ...
                        'archive_multiplier: Multiples of population size', num2str(obj.archive_multiplier), ...
                        'LF: F Lower Bound', num2str(obj.LF), ...
                        'UF: F Upper Bound', num2str(obj.UF), ...
                        'LCR: CR Lower Bound', num2str(obj.LCR), ...
                        'UCR: CR Upper Bound', num2str(obj.UCR)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.alpha = str2double(parameter_cell{count}); count = count + 1;
            obj.replace_rate = str2double(parameter_cell{count}); count = count + 1;
            obj.shrink_rate = str2double(parameter_cell{count}); count = count + 1;
            obj.ro = str2double(parameter_cell{count}); count = count + 1;
            obj.archive_multiplier = str2double(parameter_cell{count}); count = count + 1;
            obj.LF = str2double(parameter_cell{count}); count = count + 1;
            obj.UF = str2double(parameter_cell{count}); count = count + 1;
            obj.LCR = str2double(parameter_cell{count}); count = count + 1;
            obj.UCR = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            tic

            archive = cell(1, length(Tasks));
            possibility = zeros(length(Tasks), length(Tasks));
            reward = ones(length(Tasks), length(Tasks));
            population = {};
            fnceval_calls = 0;

            for t = 1:length(Tasks)
                [population{t}, calls] = initialize(Individual, sub_pop, Tasks(t), 1);
                fnceval_calls = fnceval_calls + calls;

                for i = 1:length(population{t})
                    % max dims rnvec
                    if Tasks(t).dims < max([Tasks.dims])
                        population{t}(i).rnvec = [population{t}(i).rnvec, rand(1, max([Tasks.dims]) - Tasks(t).dims)];
                    end
                    % update archive
                    archive = obj.putarchive(archive, t, population{t}(i), sub_pop);
                end

                [bestobj(t), idx] = min([population{t}.factorial_costs]);
                data.bestX{t} = population{t}(idx).rnvec;
                data.convergence(t, 1) = bestobj(t);
            end

            generation = 1;
            while generation < iter_num && fnceval_calls < eva_num
                generation = generation + 1;

                for t = 1:length(Tasks)
                    if rand > obj.alpha
                        F = obj.LF + (obj.UF - obj.LF) * rand;
                        CR = obj.LCR + (obj.UCR - obj.LCR) * rand;

                        % generation
                        [offspring, calls] = OperatorDE.generate(1, population{t}, Tasks(t), F, CR);
                        fnceval_calls = fnceval_calls + calls;

                        % selection
                        replace = [population{t}.factorial_costs] > [offspring.factorial_costs];
                        population{t}(replace) = offspring(replace);
                        [bestobj_now, idx] = min([population{t}.factorial_costs]);
                        if bestobj_now < bestobj(t)
                            bestobj(t) = bestobj_now;
                            data.bestX{t} = population{t}(idx).rnvec;
                        end
                    else
                        % Knowledge transfer
                        [transfer_task, possibility] = obj.adaptivechoose(t, length(Tasks), archive, reward, possibility, Tasks);

                        % crossover
                        CR = obj.LCR + (obj.UCR - obj.LCR) * rand;
                        for i = 1:length(population{t})
                            offspring(i) = Individual();
                            offspring(i).rnvec = population{t}(i).rnvec;
                            r1 = randi(length(Tasks(transfer_task)));
                            offspring(i) = OperatorDE.crossover(offspring(i), population{transfer_task}(r1), CR);
                        end
                        [offspring, calls] = evaluate(offspring, Tasks(t), 1);
                        fnceval_calls = fnceval_calls + calls;

                        % selection
                        replace = [population{t}.factorial_costs] > [offspring.factorial_costs];
                        population{t}(replace) = offspring(replace);

                        [bestobj_now, idx] = min([population{t}.factorial_costs]);
                        if bestobj_now < bestobj(t)
                            reward(t, transfer_task) = reward(t, transfer_task) / obj.shrink_rate;
                            bestobj(t) = bestobj_now;
                            data.bestX{t} = population{t}(idx).rnvec;
                        else
                            reward(t, transfer_task) = reward(t, transfer_task) * obj.shrink_rate;
                        end
                    end
                    % update archive
                    for i = 1:length(population{t})
                        if rand < obj.replace_rate
                            archive = obj.putarchive(archive, t, population{t}(i), sub_pop);
                        end
                    end
                end
                data.convergence(:, generation) = bestobj;
            end
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end

        function [num, possibility] = adaptivechoose(obj, task_num, no_of_tasks, archive, reward, possibility, Tasks)
            sum = 0;
            sim = obj.calSIM(task_num, no_of_tasks, archive, Tasks);
            % update possibility table
            for i = 1:no_of_tasks
                if i == task_num
                    continue;
                end
                possibility(task_num, i) = obj.ro * possibility(task_num, i) + reward(task_num, i) / (1 + log(1 + sim(i, 1)));
                sum = sum + possibility(task_num, i);
            end

            p = rand;
            s = 0;
            for i = 1:no_of_tasks
                if i == task_num
                    continue;
                end
                s = s + possibility(task_num, i) / sum;
                if s >= p
                    break;
                end
            end
            num = i;
        end

        function archive = putarchive(obj, archive, task_num, individual, sub_pop)
            max_size = obj.archive_multiplier * sub_pop;
            archive_size = size(archive{task_num}, 1); %当前该任务的成员数
            if archive_size < max_size
                archive_size = archive_size + 1;
                archive{task_num}(archive_size, 1) = individual;
            else
                while 1
                    l = ceil(rand * max_size);
                    if l ~= 0
                        break;
                    end
                end
                archive{task_num}(l, 1) = individual;
            end
        end

        function similarity = calSIM(obj, task_num, no_of_task, archive, Tasks)
            % Calculate similarity
            for i = 1:no_of_task
                if task_num ~= i
                    NVARS = min(Tasks(task_num).dims, Tasks(i).dims); %向维度较低的任务统一维度
                    cov0 = obj.getCov(task_num, archive, NVARS);
                    cov1 = obj.getCov(i, archive, NVARS);
                    cov0_det = det(cov0);
                    Inv_cov0 = pinv(cov0);
                    cov1_det = det(cov1);
                    Inv_cov1 = pinv(cov1);
                    tr = obj.getTrace(Inv_cov1, cov0);
                    u = obj.getMul(task_num, i, archive, NVARS, Inv_cov1);
                    if cov0_det < 1e-3
                        cov0_det = 0.001;
                    end
                    if cov1_det < 1e-3
                        cov1_det = 0.001;
                    end
                    s1 = abs(0.5 * (tr + u - NVARS + log(cov1_det / cov0_det)));
                    tr = obj.getTrace(Inv_cov0, cov1);
                    u = obj.getMul(i, task_num, archive, NVARS, Inv_cov0);
                    s2 = abs(0.5 * (tr + u - NVARS + log(cov0_det / cov1_det)));
                    similarity(i, 1) = 0.5 * (s1 + s2);
                end
            end
        end

        function COV = getCov(obj, task_num, archive, NVARS)
            % 生成NVARS*NVARS维的协方差矩阵
            cur_ar_size = size(archive{task_num}, 1);
            pop_rnvec = zeros(cur_ar_size, NVARS);
            for i = 1:cur_ar_size
                pop_rnvec(i, :) = archive{task_num}(i).rnvec(1:NVARS);
            end
            COV = cov(pop_rnvec);
        end

        function tr = getTrace(obj, inv_cov1, cov2)
            % inv_cov1为matrix1的逆，cov2为matrix2
            % KLD计算的第一项
            fmatrix = inv_cov1 * cov2;
            tr = sum(diag(fmatrix));
        end

        function u = getMul(obj, t0, t1, archive, NVARS, invcov)
            % t0,t1分别为任意两个任务编号
            % NVARS为任务的维度
            % invcov为协方差矩阵的逆
            % KLD计算第二项
            pop0_archive = archive{t0}; %t1种群的档案
            pop1_archive = archive{t1}; %t2种群的档案
            cur_ar_size0 = size(pop0_archive, 1);
            cur_ar_size1 = size(pop1_archive, 1);
            pop0_rnvec = zeros(cur_ar_size0, NVARS);
            pop1_rnvec = zeros(cur_ar_size1, NVARS);
            for i = 1:cur_ar_size0
                pop0_rnvec(i, :) = pop0_archive(i).rnvec(1:NVARS);
            end
            for i = 1:cur_ar_size1
                pop1_rnvec(i, :) = pop1_archive(i).rnvec(1:NVARS);
            end
            u0 = mean(pop0_rnvec);
            u1 = mean(pop1_rnvec);
            u = (u1 - u0) * invcov * (u1 - u0)';
        end
    end
end
