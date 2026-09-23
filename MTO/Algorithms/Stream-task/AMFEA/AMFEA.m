classdef AMFEA < StreamAlgorithm
% <Multi-task> <Single-objective> <None/Constrained> <Stream> <Year: 2016>
% Asynchronous MFEA: implicit transfer is restricted to currently active tasks.

%------------------------------- Reference --------------------------------
% @Article{Gupta2016MFEA,
%   title      = {Multifactorial Evolution: Toward Evolutionary Multitasking},
%   author     = {Gupta, Abhishek and Ong, Yew-Soon and Feng, Liang},
%   journal    = {IEEE Transactions on Evolutionary Computation},
%   year       = {2016},
%   number     = {3},
%   pages      = {343-357},
%   volume     = {20},
%   doi        = {10.1109/TEVC.2015.2458037},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    RMP = 0.3
    MuC = 2
    MuM = 5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.RMP = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i});
    end

    function offspring = Generation(Algo, population, sourceTasks, target)
        % Anchor each child to the target task so its evaluation consumes the
        % target's local budget. Sample the second parent directly from a
        % current active task instead of concatenating all task populations.
        n = numel(population);
        order = randperm(n);
        offspring = population(order);
        parentDec = offspring.Decs;

        % All ready populations have the same size N, so sampling a task and
        % then an individual is equivalent to uniform sampling from the old
        % concatenated pool without constructing that pool.
        sources = sourceTasks(randi(numel(sourceTasks), 1, n));
        partnerDec = zeros(size(parentDec));
        for source = unique(sources)
            positions = find(sources == source);
            sourcePopulation = Algo.Population{source};
            selected = randi(numel(sourcePopulation), 1, numel(positions));
            partnerDec(positions, :) = sourcePopulation(selected).Decs;
        end

        crossover = sources == target | rand(1, n) < Algo.RMP;
        offspringDec = parentDec;
        if any(crossover)
            offspringDec(crossover, :) = Algo.crossoverRows( ...
                parentDec(crossover, :), partnerDec(crossover, :));
        end
        if any(~crossover)
            offspringDec(~crossover, :) = Algo.mutateRows(parentDec(~crossover, :));
        end
        offspringDec = BoundaryClip(offspringDec);

        for i = 1:n
            offspring(i).Dec = offspringDec(i, :);
            % Vertical cultural transmission is fixed to the target because
            % stream-task budgets are maintained independently per task.
            offspring(i).MFFactor = target;
        end
    end
end

methods (Access = protected)
    function onEvent(Algo, Prob, event, tasks) %#ok<INUSD>
        if ~strcmp(event, 'start'), return; end
        assert(Prob.N >= 2, 'AMFEA requires N >= 2.');
        Algo.Shared.Ready = false(1, Prob.T);
    end

    function step(Algo, Prob, active)
        t = active(1);
        if ~Algo.Shared.Ready(t)
            % New tasks start independently. In particular, completed tasks
            % are not used as warm-start transfer sources.
            if StreamInitializePopulation(Algo, Prob, t, @Individual_MF, false)
                Algo.Population{t} = Algo.setFactorData(Algo.Population{t}, t, Prob.T);
            end
            return;
        end

        s = Algo.State{t};
        if isempty(s.Batch)
            % 'active' is supplied by StreamAlgorithm and contains exactly
            % the arrived, unfinished tasks at the current stream clock.
            donors = sort(active(active ~= t & Algo.Shared.Ready(active)));
            [s.Batch, s.Context] = Algo.makeBatch(Prob, t, donors);
            s.Offset = 0;
            s.Context.Improved = false;
        end

        [s, complete] = StreamEvaluateBatch(Algo, Prob, t, s);
        if complete
            Algo.acceptBatch(Prob, t, s.Batch(1:s.Offset));
            s.Batch = [];
            s.Offset = 0;
        end
        Algo.State{t} = s;
    end

    function [batch, context] = makeBatch(Algo, ~, t, donors)
        activeTasks = [t, donors];
        batch = Algo.Generation(Algo.Population{t}, activeTasks, t);
        context = struct('ActiveTasks', activeTasks, 'Clock', Algo.Clock, ...
            'TaskFE', Algo.TaskFE);
    end

    function acceptBatch(Algo, Prob, t, batch)
        batch = Algo.setFactorData(batch, t, Prob.T);
        pool = [Algo.Population{t}, batch];
        [~, rank] = sortrows([pool.CVs, pool.Objs]);
        Algo.Population{t} = pool(rank(1:min(Prob.N, numel(pool))));
    end
end

methods (Access = private)
    function offspringDec = crossoverRows(Algo, parentDec, partnerDec)
        [count, dimension] = size(parentDec);
        u = rand(count, dimension);
        beta = zeros(count, dimension);
        lower = u <= 0.5;
        beta(lower) = (2 * u(lower)).^(1 / (Algo.MuC + 1));
        beta(~lower) = (2 * (1 - u(~lower))).^(-1 / (Algo.MuC + 1));
        beta = beta .* (-1).^randi([0, 1], count, dimension);
        beta(rand(count, dimension) < 0.5) = 1;

        first = rand(count, 1) < 0.5;
        offspringDec = 0.5 * ((1 + beta) .* partnerDec + ...
            (1 - beta) .* parentDec);
        offspringDec(first, :) = 0.5 * ((1 + beta(first, :)) .* parentDec(first, :) + ...
            (1 - beta(first, :)) .* partnerDec(first, :));
    end

    function dec = mutateRows(Algo, dec)
        dimension = size(dec, 2);
        mask = rand(size(dec)) < 1 / dimension;
        if ~any(mask(:)), return; end

        values = dec(mask);
        u = rand(size(values));
        delta = zeros(size(values));
        lower = u <= 0.5;
        delta(lower) = (2 * u(lower) + (1 - 2 * u(lower)) .* ...
            (1 - values(lower)).^(Algo.MuM + 1)).^(1 / (Algo.MuM + 1)) - 1;
        delta(~lower) = 1 - (2 * (1 - u(~lower)) + ...
            2 * (u(~lower) - 0.5) .* values(~lower).^(Algo.MuM + 1)).^ ...
            (1 / (Algo.MuM + 1));
        dec(mask) = values + delta;
    end

    function population = setFactorData(Algo, population, t, taskCount) %#ok<INUSD>
        for i = 1:numel(population)
            population(i).MFObj = inf(1, taskCount);
            population(i).MFCV = inf(1, taskCount);
            population(i).MFRank = inf(1, taskCount);
            population(i).MFObj(t) = population(i).Obj;
            population(i).MFCV(t) = population(i).CV;
            population(i).MFFactor = t;
        end
    end
end
end
