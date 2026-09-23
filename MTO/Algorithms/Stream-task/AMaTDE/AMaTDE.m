classdef AMaTDE < StreamAlgorithm
% <Multi-task/Many-task> <Single-objective> <None/Constrained> <Stream> <Year: 2020>
% Author AMTO baseline adapted to StreamAlgorithm; all evaluations count.

%------------------------------- Reference --------------------------------
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
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

%------------------------------- Reference --------------------------------
% @Article{Han2026KR_AMTEA,
%   title      = {Multitense Knowledge Transfer for Asynchronous Multitasking Optimization},
%   author     = {Han, Honggui and Zhao, Ben and Wu, Xiaolong and Li, Xin},
%   journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
%   year       = {2026},
%   volume     = {56},
%   number     = {5},
%   pages      = {3370--3383},
%   doi        = {10.1109/TSMC.2026.3658328},
% }
%--------------------------------------------------------------------------

properties
    Alpha = 0.1
    ArcUpdate = 0.2
    Shrink = 0.8
    Ro = 0.8
    ArcMultip = 3
    LF = 0.1
    UF = 2
    LCR = 0.1
    UCR = 0.9
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Alpha: Knowledge Transfer Rate', num2str(Algo.Alpha), ...
                'ArcUpdate: Archive Update Rate', num2str(Algo.ArcUpdate), ...
                'Shrink: Reward Shrink Rate', num2str(Algo.Shrink), ...
                'Ro: Attenuation Coefficient', num2str(Algo.Ro), ...
                'ArcMultip: Multiples of population size', num2str(Algo.ArcMultip), ...
                'LF: F Lower Bound', num2str(Algo.LF), ...
                'UF: F Upper Bound', num2str(Algo.UF), ...
                'LCR: CR Lower Bound', num2str(Algo.LCR), ...
                'UCR: CR Upper Bound', num2str(Algo.UCR)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Alpha = str2double(Parameter{i}); i = i + 1;
        Algo.ArcUpdate = str2double(Parameter{i}); i = i + 1;
        Algo.Shrink = str2double(Parameter{i}); i = i + 1;
        Algo.Ro = str2double(Parameter{i}); i = i + 1;
        Algo.ArcMultip = str2double(Parameter{i}); i = i + 1;
        Algo.LF = str2double(Parameter{i}); i = i + 1;
        Algo.UF = str2double(Parameter{i}); i = i + 1;
        Algo.LCR = str2double(Parameter{i}); i = i + 1;
        Algo.UCR = str2double(Parameter{i}); i = i + 1;
    end

end

methods (Access = protected)
    function onEvent(Algo, Prob, event, tasks) %#ok<INUSD>
        if ~strcmp(event, 'start'), return; end
        assert(Prob.N >= 4, 'Stream population algorithms require N >= 4.');
        Algo.Shared.Ready = false(1, Prob.T);
        Algo.Shared.Possibility = zeros(Prob.T); Algo.Shared.Reward = ones(Prob.T);
        Algo.Shared.Archive = cell(1, Prob.T);
    end

    function step(Algo, Prob, active)
        t = active(1);
        if ~Algo.Shared.Ready(t)
            if StreamInitializePopulation(Algo, Prob, t, @Individual_DE, true)
                % Build the archive after initialization so similarity uses evaluated individuals.
                for i = 1:Prob.N
                    Algo.Shared.Archive = Algo.putarchive(Algo.Shared.Archive, t, Algo.Population{t}(i), Prob.N);
                end
            end
            return;
        end
        % Generate candidates only for a new batch; resume existing candidates after arrival events.
        s = Algo.State{t};
        if isempty(s.Batch)
            donors = sort(active(active ~= t & Algo.Shared.Ready(active)));
            [s.Batch, s.Context] = Algo.makeBatch(Prob, t, donors);
            s.Offset = 0; s.Context.Improved = false;
        end
        % Apply selection once the batch finishes, preserving update rules across arrival events.
        [s, complete] = StreamEvaluateBatch(Algo, Prob, t, s);
        if complete
            Algo.acceptBatch(Prob, t, s.Batch(1:s.Offset), s.Context);
            s.Batch = []; s.Offset = 0;
        end
        Algo.State{t} = s;
    end

    function [batch, context] = makeBatch(Algo, Prob, t, donors)
        context = struct('Source', 0);
        if rand > Algo.Alpha || isempty(donors)
            for i = 1:Prob.N
                Algo.Population{t}(i).F = Algo.LF + (Algo.UF - Algo.LF) * rand;
                Algo.Population{t}(i).CR = Algo.LCR + (Algo.UCR - Algo.LCR) * rand;
            end
            batch = Algo.Generation(Algo.Population{t});
        else
            [source, Algo.Shared.Possibility] = Algo.adaptivechoose(t, Prob.T, ...
                Algo.Shared.Archive, Algo.Shared.Reward, Algo.Shared.Possibility, Prob.D, Prob);
            context.Source = source; batch = Algo.Population{t};
            for i = 1:Prob.N
                cr = Algo.LCR + (Algo.UCR - Algo.LCR) * rand;
                r = randi(numel(Algo.Population{source}));
                batch(i).Dec = DE_Crossover(batch(i).Dec, Algo.Population{source}(r).Dec, cr);
            end
        end
    end
    function acceptBatch(Algo, Prob, t, batch, context)
        n = numel(batch);
        Algo.Population{t}(1:n) = Selection_Tournament(Algo.Population{t}(1:n), batch);
        % Reward the source if any evaluation in the transfer batch improves the task best.
        if context.Source > 0
            if context.Improved, factor = 1 / Algo.Shrink; else, factor = Algo.Shrink; end
            Algo.Shared.Reward(t, context.Source) = Algo.Shared.Reward(t, context.Source) * factor;
        end
        for i = 1:Prob.N
            if rand < Algo.ArcUpdate
                Algo.Shared.Archive = Algo.putarchive(Algo.Shared.Archive, t, Algo.Population{t}(i), Prob.N);
            end
        end
    end
end

methods
    function offspring = Generation(Algo, population)
        for i = 1:length(population)
            offspring(i) = population(i);
            A = randperm(length(population), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
            % Move the current individual toward a random peer, preserving the author's random draws.
            x1 = i; x3 = i;
            offspring(i).Dec = population(x1).Dec + population(i).F * (population(x2).Dec - population(x3).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, population(i).CR);

            rand_Dec = rand(1, length(offspring(i).Dec));
            offspring(i).Dec(offspring(i).Dec > 1) = rand_Dec(offspring(i).Dec > 1);
            offspring(i).Dec(offspring(i).Dec < 0) = rand_Dec(offspring(i).Dec < 0);
        end
    end

    function [num, possibility] = adaptivechoose(Algo, task_idx, T, archive, reward, possibility, Dim, Prob)
        sum = 0;
        % Update source probabilities only for initialized, active tasks.
        sim = Algo.calSIM(task_idx, T, archive, Dim, Prob);
        % update possibility table
        for i = 1:T
            if i == task_idx
                continue;
            end
            if ~Algo.Shared.Ready(i) || Algo.Completed(i)
                possibility(task_idx, i) = 0;
                continue;
            end
            possibility(task_idx, i) = Algo.Ro * possibility(task_idx, i) + reward(task_idx, i) / (1 + log(1 + sim(i, 1)));
            sum = sum + possibility(task_idx, i);
        end
        p = rand;
        s = 0;
        for i = 1:T
            if i == task_idx
                continue;
            end
            s = s + possibility(task_idx, i) / sum;
            if s >= p
                break;
            end
        end
        num = i;
    end

    function archive = putarchive(Algo, archive, task_idx, individual, N)
        max_size = Algo.ArcMultip * N;
        archive_size = size(archive{task_idx}, 1);
        if archive_size < max_size
            archive_size = archive_size + 1;
            archive{task_idx}(archive_size, 1) = individual;
        else
            while 1
                l = ceil(rand * max_size);
                if l ~= 0
                    break;
                end
            end
            archive{task_idx}(l, 1) = individual;
        end
    end

    function similarity = calSIM(Algo, task_idx, T, archive, Dim, Prob)
        % Calculate similarity
        for i = 1:T
            if ~Algo.Shared.Ready(i) || Algo.Completed(i)
                similarity(i, 1) = 0;
                continue;
            end
            if task_idx ~= i
                NVARS = min(Dim(task_idx), Dim(i)); % Unify dimensions to lower task
                cov0 = Algo.getCov(task_idx, archive, NVARS);
                cov1 = Algo.getCov(i, archive, NVARS);
                cov0_det = det(cov0);
                Inv_cov0 = pinv(cov0);
                cov1_det = det(cov1);
                if isnan(cov1)
                    Inv_cov1 = 0.001;
                else
                    Inv_cov1 = pinv(cov1);
                end

                tr = Algo.getTrace(Inv_cov1, cov0);
                u = Algo.getMul(task_idx, i, archive, NVARS, Inv_cov1);
                if cov0_det < 1e-3
                    cov0_det = 0.001;
                end
                if cov1_det < 1e-3
                    cov1_det = 0.001;
                end
                s1 = abs(0.5 * (tr + u - NVARS + log(cov1_det / cov0_det)));
                tr = Algo.getTrace(Inv_cov0, cov1);
                u = Algo.getMul(i, task_idx, archive, NVARS, Inv_cov0);
                s2 = abs(0.5 * (tr + u - NVARS + log(cov0_det / cov1_det)));
                similarity(i, 1) = 0.5 * (s1 + s2);
            end
        end
    end

    function COV = getCov(Algo, task_idx, archive, NVARS)
        % generate NVARS*NVARS Dim cov matrix
        cur_ar_size = size(archive{task_idx}, 1);
        pop_Dec = zeros(cur_ar_size, NVARS);
        for i = 1:cur_ar_size
            pop_Dec(i, :) = archive{task_idx}(i).Dec(1:NVARS);
        end
        COV = cov(pop_Dec);
    end

    function tr = getTrace(Algo, inv_cov1, cov2)
        % KLD first step
        fmatrix = inv_cov1 * cov2;
        tr = sum(diag(fmatrix));
    end

    function u = getMul(Algo, t0, t1, archive, NVARS, invcov)
        % KLD second step
        pop0_archive = archive{t0};
        pop1_archive = archive{t1};
        cur_ar_size0 = size(pop0_archive, 1);
        cur_ar_size1 = size(pop1_archive, 1);
        pop0_Dec = zeros(cur_ar_size0, NVARS);
        pop1_Dec = zeros(cur_ar_size1, NVARS);
        for i = 1:cur_ar_size0
            pop0_Dec(i, :) = pop0_archive(i).Dec(1:NVARS);
        end
        for i = 1:cur_ar_size1
            pop1_Dec(i, :) = pop1_archive(i).Dec(1:NVARS);
        end
        u0 = mean(pop0_Dec);
        u1 = mean(pop1_Dec);
        u = (u1 - u0) * invcov * (u1 - u0)';
    end
end
end
