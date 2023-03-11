classdef BoKTGA < Algorithm
% <Many-task> <Single-objective> <None>

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
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    sigma = 0.9
    MuC = 2
    MuM = 5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Sigma: Decay rate', num2str(Algo.sigma), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.sigma = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        ntask = Prob.T;
        lambda = 0.5 * ones(1, ntask);
        dim = max(Prob.D);
        pop = Initialization(Algo, Prob, Individual);
        archive = cell(ntask, ntask);
        for i = 1:ntask
            [~, best_index] = min(pop{i}.Objs);
            b_x = pop{i}(best_index);
            for j = 1:ntask
                if i == j
                    archive{i, j} = b_x;
                else
                    Algo.Evaluation(b_x, Prob, j);
                    archive{i, j} = b_x;
                end
            end
        end
        task_center = {};
        task_best = {};

        % save_gap = 10000;
        % cur_gap = 0;

        while Algo.notTerminated(Prob)
            % if Algo.FE >= cur_gap
            %     data = [];
            %     for t = 1:ntask
            %         data = [data, min(pop{t}.Objs)];
            %     end
            %     disp(['fes:', num2str(Algo.FE), ' avgfit: ', num2str(mean(data))]);
            %     cur_gap = cur_gap + save_gap;
            % end

            case1 = 0;
            case2 = 0;
            case3 = 0;
            total1 = 0;
            total2 = 0;
            total3 = 0;
            % renew the archive
            for t = 1:ntask
                [~, best_index] = min(pop{t}.Objs);
                b_x = pop{t}(best_index);
                rt = randi(ntask);
                while rt == t
                    rt = randi(ntask);
                end
                b_x = Algo.Evaluation(b_x, Prob, rt);
                if b_x.Obj < archive{t, rt}.Obj
                    archive{t, rt} = b_x;
                end
                if b_x.Obj < min(pop{rt}.Objs)
                    [~, rt_worst] = max(pop{rt}.Objs);
                    pop{rt}(rt_worst) = b_x;
                end
            end
            % find task center and task best
            for t = 1:ntask
                task_center{t} = mean(pop{t}.Decs, 1);
                [~, i_best] = min(pop{t}.Objs);
                task_best{t} = pop{t}(i_best).Dec;
            end

            pos_obj = zeros(ntask, ntask);
            dis_obj = zeros(ntask, ntask);
            pos_rank = zeros(ntask, ntask);
            dis_rank = zeros(ntask, ntask);
            %pos rank
            for i = 1:ntask
                for j = 1:ntask
                    if i == j
                        pos_obj(j, i) = inf;
                    else
                        pos_obj(j, i) = archive{j, i}.Obj;
                    end
                end
            end
            for i = 1:ntask
                [~, temp_rank] = sort(pos_obj(:, i), 'ascend');
                for j = 1:ntask
                    pos_rank(temp_rank(j), i) = j - 1;
                end
            end
            %dis
            mean_list = {};
            cov_list = {};
            for i = 1:ntask
                cur_pop = pop{i}.Decs;
                for j = 1:Prob.N
                    cur_pop(j, :) = cur_pop(j, :) - task_center{i};
                end
                mean_list{i} = mean(cur_pop)';
                covi = cov(cur_pop);
                cov_list{i} = covi;
            end

            for i = 1:ntask
                for j = i:ntask
                    if i == j
                        dis_obj(i, j) = inf;
                    else
                        dis_obj(i, j) = 0.5 * (mvgkl(mean_list{i}, mean_list{j}, cov_list{i}, cov_list{j}) + mvgkl(mean_list{j}, mean_list{i}, cov_list{j}, cov_list{i}));
                        dis_obj(j, i) = dis_obj(i, j);
                    end
                end
            end

            for i = 1:ntask
                [~, temp_rank] = sort(dis_obj(:, i), 'ascend');
                for j = 1:ntask
                    dis_rank(temp_rank(j), i) = j - 1;
                end
            end
            %find non dominate task
            level1 = {};
            for i = 1:ntask
                obj1 = pos_obj(:, i);
                obj2 = dis_obj(:, i);
                cur_level1 = [];
                for j = 1:length(obj1)
                    mask = 0;
                    for z = 1:length(obj1)
                        if z == j
                            continue;
                        end
                        if ((obj1(z) <= obj1(j) && obj2(z) < obj2(j)) || (obj1(z) < obj1(j) && obj2(z) <= obj2(j)))
                            mask = 1;
                        end
                    end
                    if mask == 0
                        cur_level1 = [cur_level1, j];
                    end
                end
                level1{i} = cur_level1;
            end
            %%
            %evolutionary operation
            for t = 1:ntask
                Q = pop{t}.Decs;
                childpop = pop{t};
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
                        Q1 = pop{rt}.Decs;
                        Q2 = [Q; Q1];
                    else
                        strategy = 2;
                        Q1 = pop{rt}.Decs;
                        for j = 1:Prob.N
                            Q1(j, :) = Q1(j, :) - task_center{rt} + task_center{t};
                        end
                        Q2 = [Q; Q1];
                        q2m = mean(Q2, 1);
                        q2c = std(Q2);
                    end
                end

                for j = 1:Prob.N
                    if rand() < lambda(t) || strategy == 0
                        r1 = randi(Prob.N);
                        r2 = randi(Prob.N);
                        while r1 == r2
                            r1 = randi(Prob.N);
                            r2 = randi(Prob.N);
                        end
                        p1 = Q(r1, :);
                        p2 = Q(r2, :);
                        [c1, c2] = GA_Crossover(p1, p2, Algo.MuC);
                        c1 = GA_Mutation(c1, Algo.MuM);
                        c2 = GA_Mutation(c2, Algo.MuM);
                        if rand() < 0.5
                            u = c1;
                        else
                            u = c2;
                        end
                        mask = [mask, 0];
                        total1 = total1 + 1;
                    else
                        if strategy == 1
                            r2 = randi(size(Q2, 1));
                            p1 = Q(j, :);
                            p2 = Q2(r2, :);
                            [c1, c2] = GA_Crossover(p1, p2, Algo.MuC);
                            c1 = GA_Mutation(c1, Algo.MuM);
                            c2 = GA_Mutation(c2, Algo.MuM);
                            if rand() < 0.5
                                u = c1;
                            else
                                u = c2;
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
                    childpop(j).Dec = u;
                    childpop(i).Dec(childpop(i).Dec > 1) = 1;
                    childpop(i).Dec(childpop(i).Dec < 0) = 0;
                end

                % Evaluation
                childpop = Algo.Evaluation(childpop, Prob, t);
                childpop = [childpop, pop{t}];
                [~, rank] = sort(childpop.Objs, 'ascend');

                for i = 1:Prob.N
                    pop{t}(i) = childpop(rank(i));
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

                task_center{t} = mean(pop{t}.Decs);
                [~, i_best] = min(pop{t}.Objs);
                task_best{t} = pop{t}(i_best).Dec;
                rate1 = case1 / (total1 +1e-10);
                rate2 = (case2 + case3) / (total2 + total3 +1e-10);
                lambda(t) = Algo.sigma * lambda(t) + (1 - Algo.sigma) * (rate1 / (rate2 + rate1));
            end
        end
    end
end
end
