classdef ABoKTDE < StreamAlgorithm
% <Multi-task/Many-task> <Single-objective> <None> <Stream> <Year: 2023>
% BoKTDE adapted to streams; knowledge sources must be initialized and active.

%------------------------------- Reference --------------------------------
% @Article{Jiang2023BoKT,
%   author   = {Jiang, Yi and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   title    = {A Bi-Objective Knowledge Transfer Framework for Evolutionary Many-Task Optimization},
%   year     = {2023},
%   pages    = {1514-1528},
%   doi      = {10.1109/TEVC.2022.3210783},
%   volume   = {27},
%   number   = {5},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

properties
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
        Algo.Sigma = str2double(Parameter{1});
        Algo.F = str2double(Parameter{2});
        Algo.CR = str2double(Parameter{3});
    end
end

methods (Access = protected)
    function onEvent(Algo, Prob, event, tasks) %#ok<INUSD>
        if ~strcmp(event, 'start'), return; end
        validateattributes(Prob.N, {'numeric'}, {'scalar', 'integer', '>=', 3});
        validateattributes(Algo.Sigma, {'numeric'}, {'scalar', 'finite', '>=', 0, '<=', 1});
        validateattributes(Algo.F, {'numeric'}, {'scalar', 'finite', '>=', 0});
        validateattributes(Algo.CR, {'numeric'}, {'scalar', 'finite', '>=', 0, '<=', 1});
        Algo.Shared.Ready = false(1, Prob.T);
        Algo.Shared.Lambda = 0.5 * ones(1, Prob.T);
        % Archive{source,target} stores the best cross-evaluated source elite.
        Algo.Shared.Archive = cell(Prob.T, Prob.T);
    end

    function step(Algo, Prob, active)
        t = active(1);
        if ~Algo.Shared.Ready(t)
            % No warm start: neither completed nor future tasks supply knowledge.
            if StreamInitializePopulation(Algo, Prob, t, @Individual, false)
                Algo.State{t}.Probing = false;
                Algo.State{t}.ProbeQueue = [];
            end
            return;
        end

        donors = sort(active(active ~= t & Algo.Shared.Ready(active)));
        s = Algo.State{t};
        if isempty(s.Batch)
            missing = donors(cellfun(@isempty, Algo.Shared.Archive(donors, t)));
            missing = reshape(missing, 1, []);
            if ~s.Probing
                % Bootstrap unknown pairs; otherwise refresh one random source
                % per target generation, counting every probe on the target.
                s.ProbeQueue = missing;
                if isempty(missing) && ~isempty(donors)
                    s.ProbeQueue = donors(randi(numel(donors)));
                end
                s.Probing = true;
            else
                % An arrival may introduce new ready sources while probing.
                s.ProbeQueue = s.ProbeQueue(ismember(s.ProbeQueue, donors));
                s.ProbeQueue = unique([s.ProbeQueue, missing], 'stable');
            end
            while ~isempty(s.ProbeQueue) && Algo.remainingFE(Prob, t) > 0
                source = s.ProbeQueue(1);
                Algo.State{t} = s;
                Algo.probeSource(Prob, t, source);
                s.ProbeQueue(1) = [];
            end
            if Algo.remainingFE(Prob, t) == 0
                Algo.State{t} = s;
                return;
            end
            [s.Batch, s.Context] = Algo.makeBatch(Prob, t, donors);
            s.Offset = 0;
            s.Context.Improved = false;
        elseif s.Context.Source > 0 && ~ismember(s.Context.Source, donors)
            % The donor completed while this batch was paused. Preserve the
            % evaluated prefix and replace only the pending tail with self DE.
            [replacement, context] = Algo.makeBatch(Prob, t, []);
            pending = s.Offset + 1:numel(s.Batch);
            s.Batch(pending) = replacement(pending);
            s.Context.Mask(pending) = context.Mask(pending);
            s.Context.Sources(pending) = 0;
            s.Context.Source = 0;
        end

        Algo.State{t} = s;
        [s, complete] = StreamEvaluateBatch(Algo, Prob, t, s);
        if complete
            Algo.acceptBatch(Prob, t, s.Batch(1:s.Offset), s.Context);
            s.Batch = []; s.Offset = 0;
            s.Probing = false; s.ProbeQueue = [];
        end
        Algo.State{t} = s;
    end

    function probeSource(Algo, Prob, t, source)
        [~, best] = min(Algo.Population{source}.Objs);
        probe = Algo.Evaluation(Algo.Population{source}(best), Prob, t);
        previous = Algo.Shared.Archive{source, t};
        if isempty(previous) || probe.Obj < previous.Obj
            Algo.Shared.Archive{source, t} = probe;
        end
        % Preserve BoKTDE's immediate elite injection after a useful probe.
        if probe.Obj < min(Algo.Population{t}.Objs)
            [~, worst] = max(Algo.Population{t}.Objs);
            Algo.Population{t}(worst) = probe;
        end
    end

    function [source, strategy] = selectSource(Algo, Prob, t, donors)
        source = 0; strategy = 0;
        if isempty(donors), return; end
        position = inf(1, numel(donors));
        distance = inf(1, numel(donors));
        target = Algo.Population{t}.Decs;
        for i = 1:numel(donors)
            record = Algo.Shared.Archive{donors(i), t};
            if isempty(record), continue; end
            position(i) = record.Obj;
            % Ignore unused padding coordinates for unequal-dimension tasks.
            d = min(Prob.D(t), Prob.D(donors(i)));
            donor = Algo.Population{donors(i)}.Decs;
            distance(i) = Algo.distributionDistance(target(:, 1:d), donor(:, 1:d));
        end
        valid = isfinite(position) & isfinite(distance);
        donors = donors(valid); position = position(valid); distance = distance(valid);
        if isempty(donors), return; end
        front = true(1, numel(donors));
        for i = 1:numel(donors)
            dominates = position <= position(i) & distance <= distance(i) & ...
                (position < position(i) | distance < distance(i));
            front(i) = ~any(dominates);
        end
        candidates = find(front);
        chosen = candidates(randi(numel(candidates)));
        source = donors(chosen);
        [~, order] = sort(position); positionRank(order) = 0:numel(donors) - 1;
        [~, order] = sort(distance); distanceRank(order) = 0:numel(donors) - 1;
        if positionRank(chosen) < distanceRank(chosen)
            strategy = 1;
        else
            strategy = 2;
        end
    end

    function [batch, context] = makeBatch(Algo, Prob, t, donors)
        [source, strategy] = Algo.selectSource(Prob, t, donors);
        parent = Algo.Population{t}; Q = parent.Decs;
        [~, best] = min(parent.Objs); pbest = parent(best).Dec;
        if strategy > 0
            Q1 = Algo.Population{source}.Decs;
            if strategy == 2
                Q1 = Q1 - mean(Q1, 1) + mean(Q, 1);
            end
            Q2 = [Q; Q1];
            if strategy == 2
                mu = mean(Q2, 1); sd = std(Q2, 0, 1);
            end
        end
        batch = parent;
        context = struct('Source', source, 'Mask', zeros(1, Prob.N), ...
            'Sources', zeros(1, Prob.N));
        for i = 1:Prob.N
            if rand < Algo.Shared.Lambda(t) || strategy == 0
                r = randperm(size(Q, 1), 3);
                mutant = Q(r(1), :) + Algo.F * (Q(r(2), :) - Q(r(3), :));
                dec = Algo.crossover(Q(i, :), mutant);
            elseif strategy == 1
                r = randperm(size(Q2, 1), 3);
                mutant = Q2(r(1), :) + Algo.F * (pbest - Q2(r(1), :)) + ...
                    Algo.F * (Q2(r(2), :) - Q2(r(3), :));
                dec = Algo.crossover(Q(i, :), mutant);
                context.Mask(i) = 1; context.Sources(i) = source;
            else
                dec = mu + sd .* randn(1, size(Q, 2));
                context.Mask(i) = 2; context.Sources(i) = source;
            end
            batch(i).Dec = BoundaryClip(dec);
        end
    end

    function acceptBatch(Algo, Prob, t, batch, context)
        n = numel(batch);
        combined = [batch, Algo.Population{t}];
        [~, order] = sort(combined.Objs);
        selected = order(1:Prob.N);
        Algo.Population{t} = combined(selected);
        mask = context.Mask(1:n);
        survived = selected(selected <= n);
        selfCount = sum(mask == 0); transferCount = sum(mask > 0);
        % A batch without both operators provides no relative success signal.
        if selfCount == 0 || transferCount == 0, return; end
        selfRate = sum(mask(survived) == 0) / selfCount;
        transferRate = sum(mask(survived) > 0) / transferCount;
        if selfRate + transferRate > 0
            Algo.Shared.Lambda(t) = Algo.Sigma * Algo.Shared.Lambda(t) + ...
                (1 - Algo.Sigma) * selfRate / (selfRate + transferRate);
        end
    end

    function distance = distributionDistance(Algo, X, Y) %#ok<INUSD>
        % Centered symmetric Gaussian KL, with BoKTDE's covariance ridge.
        X = X - mean(X, 1); Y = Y - mean(Y, 1);
        m1 = mean(X, 1); m2 = mean(Y, 1);
        d = size(X, 2);
        S1 = cov(X) + 1e-6 * eye(d); S2 = cov(Y) + 1e-6 * eye(d);
        [R1, flag1] = chol(S1); [R2, flag2] = chol(S2);
        if flag1 || flag2, distance = Inf; return; end
        delta = m2 - m1;
        % The log determinant terms cancel in the symmetric divergence.
        distance = 0.25 * (trace(R2 \ (R2' \ S1)) + ...
            trace(R1 \ (R1' \ S2)) + sum((delta / R2).^2) + ...
            sum((delta / R1).^2) - 2 * d);
        distance = max(0, distance);
    end
end

methods (Access = private)
    function dec = crossover(Algo, parent, mutant)
        mask = rand(size(parent)) < Algo.CR;
        mask(randi(numel(parent))) = true;
        dec = parent; dec(mask) = mutant(mask);
    end
end
end
