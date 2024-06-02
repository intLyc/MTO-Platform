classdef BoKTDE < Algorithm
% <Many-task> <Single-objective> <None>

% Provided by Jiang, Yi

%------------------------------- Reference --------------------------------
% @Article{Jiang2022BoKT,
%   author   = {Jiang, Yi and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   title    = {A Bi-Objective Knowledge Transfer Framework for Evolutionary Many-Task Optimization},
%   year     = {2022},
%   pages    = {1-1},
%   doi      = {10.1109/TEVC.2022.3210783},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    Sigma = 0.9
    F = 0.5
    CR = 0.7
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Sigma: Decay rate', num2str(Algo.Sigma), ...
                'F: Scale factor', num2str(Algo.F), ...
                'CR: Crossover rate', num2str(Algo.CR)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.Sigma = str2double(Parameter{i}); i = i + 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual);
        lambda = 0.5 * ones(1, Prob.T);
        dim = max(Prob.D);
        archive = cell(Prob.T, Prob.T);
        for t = 1:Prob.T
            [~, best_index] = min(population{t}.Objs);
            b_x = population{t}(best_index);
            for k = 1:Prob.T
                if t == k
                    archive{t, k} = b_x;
                else
                    Algo.Evaluation(b_x, Prob, k);
                    archive{t, k} = b_x;
                end
            end
        end
        task_center = {};
        task_best = {};

        while Algo.notTerminated(Prob, population)
            case1 = 0;
            case2 = 0;
            case3 = 0;
            total1 = 0;
            total2 = 0;
            total3 = 0;
            % renew the archive
            for t = 1:Prob.T
                [~, best_index] = min(population{t}.Objs);
                b_x = population{t}(best_index);
                rt = randi(Prob.T);
                while rt == t
                    rt = randi(Prob.T);
                end
                b_x = Algo.Evaluation(b_x, Prob, rt);
                if b_x.Obj < archive{t, rt}.Obj
                    archive{t, rt} = b_x;
                end
                if b_x.Obj < min(population{rt}.Objs)
                    [~, rt_worst] = max(population{rt}.Objs);
                    population{rt}(rt_worst) = b_x;
                end
            end
            % find task center and task best
            for t = 1:Prob.T
                task_center{t} = mean(population{t}.Decs, 1);
                [~, i_best] = min(population{t}.Objs);
                task_best{t} = population{t}(i_best).Dec;
            end

            pos_obj = zeros(Prob.T, Prob.T);
            dis_obj = zeros(Prob.T, Prob.T);
            pos_rank = zeros(Prob.T, Prob.T);
            dis_rank = zeros(Prob.T, Prob.T);
            %pos rank
            for t = 1:Prob.T
                for k = 1:Prob.T
                    if t == k
                        pos_obj(k, t) = inf;
                    else
                        pos_obj(k, t) = archive{k, t}.Obj;
                    end
                end
            end
            for t = 1:Prob.T
                [~, temp_rank] = sort(pos_obj(:, t), 'ascend');
                for k = 1:Prob.T
                    pos_rank(temp_rank(k), t) = k - 1;
                end
            end
            %dis
            mean_list = {};
            cov_list = {};
            for t = 1:Prob.T
                cur_population = population{t}.Decs;
                for i = 1:Prob.N
                    cur_population(i, :) = cur_population(i, :) - task_center{t};
                end
                mean_list{t} = mean(cur_population)';
                covi = cov(cur_population);
                cov_list{t} = covi;
            end

            for t = 1:Prob.T
                for k = t:Prob.T
                    if t == k
                        dis_obj(t, k) = inf;
                    else
                        dis_obj(t, k) = 0.5 * (mvgkl(mean_list{t}, mean_list{k}, cov_list{t}, cov_list{k}) + mvgkl(mean_list{k}, mean_list{t}, cov_list{k}, cov_list{t}));
                        dis_obj(k, t) = dis_obj(t, k);
                    end
                end
            end

            for t = 1:Prob.T
                [~, temp_rank] = sort(dis_obj(:, t), 'ascend');
                for k = 1:Prob.T
                    dis_rank(temp_rank(k), t) = k - 1;
                end
            end
            %find non dominate task
            level1 = {};
            for t = 1:Prob.T
                obj1 = pos_obj(:, t);
                obj2 = dis_obj(:, t);
                cur_level1 = [];
                for i = 1:length(obj1)
                    mask = 0;
                    for z = 1:length(obj1)
                        if z == i
                            continue;
                        end
                        if ((obj1(z) <= obj1(i) && obj2(z) < obj2(i)) || (obj1(z) < obj1(i) && obj2(z) <= obj2(i)))
                            mask = 1;
                        end
                    end
                    if mask == 0
                        cur_level1 = [cur_level1, i];
                    end
                end
                level1{t} = cur_level1;
            end
            %evolutionary operation
            for t = 1:Prob.T
                Q = population{t}.Decs;
                offspring = population{t};
                strategy = 0;
                rt = level1{t}(randi(length(level1{t})));
                while rt == t
                    rt = level1{t}(randi(length(level1{t})));
                end
                mask = [];
                if length(level1{t}) == 1 && level1{t}(1) == t
                    disp('error');
                elseif length(level1{t}) ~= 0
                    if pos_rank(rt, t) < dis_rank(rt, t)
                        strategy = 1;
                        Q1 = population{rt}.Decs;
                        Q2 = [Q; Q1];
                    else
                        strategy = 2;
                        Q1 = population{rt}.Decs;
                        for i = 1:Prob.N
                            Q1(i, :) = Q1(i, :) - task_center{rt} + task_center{t};
                        end
                        Q2 = [Q; Q1];
                        q2m = mean(Q2, 1);
                        q2c = std(Q2);
                    end
                end

                for i = 1:Prob.N
                    if rand() < lambda(t) || strategy == 0
                        r1 = randi(size(Q, 1));
                        r2 = randi(size(Q, 1));
                        r3 = randi(size(Q, 1));
                        while r1 == r2 || r1 == r3 || r2 == r3
                            r1 = randi(size(Q, 1));
                            r2 = randi(size(Q, 1));
                            r3 = randi(size(Q, 1));
                        end
                        x1 = Q(r1, :);
                        x2 = Q(r2, :);
                        x3 = Q(r3, :);
                        xi = Q(i, :);
                        u = xi;
                        drand = randi(dim);
                        v = x1 + Algo.F * (x2 - x3);
                        for d = 1:dim
                            if rand() < Algo.CR || d == drand
                                u(d) = v(d);
                            end
                        end
                        mask = [mask, 0];
                        total1 = total1 + 1;
                    else
                        if strategy == 1
                            pbest = task_best{t};
                            r1 = randi(size(Q2, 1));
                            r2 = randi(size(Q2, 1));
                            r3 = randi(size(Q2, 1));
                            while r1 == r2 || r1 == r3 || r2 == r3
                                r1 = randi(size(Q2, 1));
                                r2 = randi(size(Q2, 1));
                                r3 = randi(size(Q2, 1));
                            end
                            x1 = Q2(r1, :);
                            x2 = Q2(r2, :);
                            x3 = Q2(r3, :);
                            xi = Q(i, :);
                            u = xi;
                            drand = randi(dim);
                            v = x1 + Algo.F * (pbest - x1) + Algo.F * (x2 - x3);
                            for d = 1:dim
                                if rand() < Algo.CR || d == drand
                                    u(d) = v(d);
                                end
                            end
                            mask = [mask, 1];
                            total2 = total2 + 1;
                        else
                            u = normrnd(q2m, q2c);
                            u = max(0, min(1, u));
                            mask = [mask, 2];
                            total3 = total3 + 1;
                        end
                    end
                    offspring(i).Dec = u;
                    offspring(i).Dec(offspring(i).Dec > 1) = 1;
                    offspring(i).Dec(offspring(i).Dec < 0) = 0;
                end

                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                offspring = [offspring, population{t}];
                [~, rank] = sort(offspring.Objs, 'ascend');

                for i = 1:Prob.N
                    population{t}(i) = offspring(rank(i));
                    if rank(i) <= Prob.N
                        if mask(rank(i)) == 0
                            case1 = case1 + 1;
                        elseif mask(rank(i)) == 1
                            case2 = case2 + 1;
                        else
                            case3 = case3 + 1;
                        end
                    end
                end

                task_center{t} = mean(population{t}.Decs);
                [~, i_best] = min(population{t}.Objs);
                task_best{t} = population{t}(i_best).Dec;
                rate1 = case1 / (total1 +1e-10);
                rate2 = (case2 + case3) / (total2 + total3 +1e-10);
                lambda(t) = Algo.Sigma * lambda(t) + (1 - Algo.Sigma) * (rate1 / (rate2 + rate1));
            end
        end
    end
end
end
