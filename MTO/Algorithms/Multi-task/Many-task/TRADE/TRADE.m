classdef TRADE < Algorithm
% <Many-task> <Single-objective> <None>

%------------------------------- Reference --------------------------------
% @Article{Wu2023TRADE,
%   title   = {Transferable Adaptive Differential Evolution for Many-Task Optimization},
%   author  = {Wu, Sheng-Hao and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
%   journal = {IEEE Transactions on Cybernetics},
%   year    = {2023},
%   pages   = {1-14},
%   doi     = {10.1109/TCYB.2023.3234969},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    G1 = 100
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'G1: First evolution stage', num2str(Algo.G1)};
    end

    function setParameter(Algo, Parameter)
        Algo.G1 = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        poolF = [0.5];
        poolCr = [0.1 0.5 0.9];
        lbF = 0.01;
        ubF = 1.0;
        lbCr = 0.01;
        ubCr = 1.0;
        mF = 0.5 * ones(1, Prob.T); % sensitive setting
        mCr = 0.5 * ones(1, Prob.T); % sensitive setting (e.g., on Schwefel, (0.95,0.05) works better than (0.5,0.5))
        sdF = 0.1 * ones(1, Prob.T);
        sdCr = 0.1 * ones(1, Prob.T);

        % count the used times of different base solvers
        paramId = zeros(1, Prob.T); % selected base solver ID
        paramCount = zeros(3, Prob.T);
        sucParamCount = zeros(3, Prob.T);

        evQuality = zeros(1, Prob.T); % evolution quality
        stage = 1;
        pseet = 0.0;

        population = Initialization(Algo, Prob, Individual_DE);
        for t = 1:Prob.T
            Arc{t} = Individual_DE.empty();
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                for i = 1:length(population{t})
                    if stage == 1
                        % stage 1 - use JADE as the base solver with the associated parameter setting to collect information data for task grouping
                        population{t}(i).F = randn() .* sdF(t) + mF(t);
                        population{t}(i).F = min(ubF, max(lbF, population{t}(i).F));
                        population{t}(i).CR = randn() .* sdCr(t) + mCr(t);
                        population{t}(i).CR = min(ubCr, max(lbCr, population{t}(i).CR));
                    else
                        % stage 2 - combining self evolution mechanism and transferring successful parameters from other tasks
                        population{t}(i).F = randn() .* sdF(t) + mF(t);
                        population{t}(i).F = min(ubF, max(lbF, population{t}(i).F));

                        % generate Cr for i-th individual
                        if rand() < pseet && rand() > 1 / task_rank(t) && groupsize(gid) > 1
                            % learn from successful evolution experience of other tasks
                            seltaskid = good_taskids(randi(good_tasks_size));
                            [~, selParamId] = max(sucParamCount(:, seltaskid) ./ (paramCount(:, seltaskid) +1e-10));
                            paramCount(selParamId, t) = paramCount(selParamId, t) + 1;

                            population{t}(i).CR = randn() .* 0.1 + poolCr(selParamId);
                            population{t}(i).CR = min(ubCr, max(lbCr, population{t}(i).CR));
                        else
                            selParamId = paramId(t);
                            paramCount(selParamId, t) = paramCount(selParamId, t) + 1;

                            population{t}(i).CR = randn() .* sdCr(t) + mCr(t);
                            population{t}(i).CR = min(ubCr, max(lbCr, population{t}(i).CR));
                        end
                    end
                end
            end

            if stage == 2
                pseet = 0.5 + 0.5 * (Algo.Gen - Algo.G1) / (Prob.maxFE / (Prob.N * Prob.T) - Algo.G1 + 1);
            end

            for t = 1:Prob.T
                if stage == 2
                    gid = groupId(t);
                    gs = groupsize(gid);
                    if gs > length(poolCr)
                        good_taskids = groupMemberId{gid}(task_rank(groupMemberId{gid}) < gs / length(poolCr));
                    else
                        good_taskids = groupMemberId{gid};
                    end
                    good_tasks_size = length(good_taskids);
                end

                union = [population{t}, Arc{t}];
                % Generation
                offspring = Algo.Generation(population{t}, union);
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                [~, replace] = Selection_Tournament(population{t}, offspring);
                if stage == 2
                    sucParamCount(selParamId, t) = sucParamCount(selParamId, t) + 1;
                end
                % Update archive
                Arc{t} = [Arc{t}, population{t}(replace)];
                if length(Arc{t}) > length(population{t})
                    Arc{t} = Arc{t}(randperm(length(Arc{t}), length(population{t})));
                end

                population{t}(replace) = offspring(replace);
            end

            % evolution quality evaluation
            if stage == 2
                for t = 1:Prob.T
                    diff1 = abs(Algo.Result(t, Algo.G1 - 1).Obj - Algo.Result(t, Algo.Gen - 1).Obj);
                    diff2 = abs(Algo.Result(t, 1).Obj - Algo.Result(t, Algo.Gen - 1).Obj);
                    evQuality(t) = diff1 / (diff2 +1e-25);
                end
            end

            % switch stage
            if Algo.Gen == Algo.G1
                stage = 2;
                task_rank = ones(1, Prob.T);
                [ngroup, groupId] = task_grouping(reshape(cat(1, Algo.Result.Obj), Prob.T, Algo.G1 - 1));
                groupsize = zeros(1, ngroup);
                groupMemberId = cell(1, ngroup);
                for gi = 1:ngroup
                    groupMemberId{gi} = find(groupId == gi);
                    groupsize(gi) = length(groupMemberId{gi});
                end

                for t = 1:Prob.T
                    mF(t) = poolF(randi(end));
                    paramId(t) = randi(length(poolCr));
                    mCr(t) = poolCr(paramId(t));
                end
            end

            % update task rank
            if stage == 2
                for gi = 1:ngroup
                    [~, ind] = sort(-evQuality(groupMemberId{gi}));
                    [~, task_rank(groupMemberId{gi})] = sort(ind);
                end
            end
        end
    end

    function offspring = Generation(Algo, population, union)
        [~, rank] = sortrows([population.CVs, population.Objs], [1, 2]);
        pop_pbest = rank(1:max(round(0.1 * length(population)), 1));

        for i = 1:length(population)
            offspring(i) = population(i);

            pbest = pop_pbest(randi(length(pop_pbest)));
            x1 = randi(length(population));
            while x1 == i || x1 == pbest
                x1 = randi(length(population));
            end
            x2 = randi(length(union));
            while x2 == i || x2 == x1 || x2 == pbest
                x2 = randi(length(union));
            end

            offspring(i).Dec = population(i).Dec + ...
                population(i).F * (population(pbest).Dec - population(i).Dec) + ...
                population(i).F * (population(x1).Dec - union(x2).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, population(i).CR);

            vio_low = find(offspring(i).Dec < 0);
            offspring(i).Dec(vio_low) = (population(i).Dec(vio_low) + 0) / 2;
            vio_up = find(offspring(i).Dec > 1);
            offspring(i).Dec(vio_up) = (population(i).Dec(vio_up) + 1) / 2;
        end
    end
end
end
