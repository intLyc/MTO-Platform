classdef ATNG_SNES < StreamAlgorithm
% <Multi-task/Many-task> <Single-objective> <None/Constrained> <Stream> <Year: 2025>
% Asynchronous TNG-SNES: average the latest complete gradients of active tasks.
% Uses TNG-SNES's unified max-D space, including the target when still active.

%------------------------------- Reference --------------------------------
% Y. Li, W. Gong, and Q. Gu, Transfer Task-averaged Natural Gradient for
% Efficient Many-task Optimization, IEEE TEVC, 29(5), 1952-1965, 2025.
% doi: 10.1109/TEVC.2024.3459862
%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

properties
    sigma0 = 0.3
    rho0 = 0.1
    alpha0 = 0.7
    adjGap = 100
    DecisionLog = struct([])
end

methods
    function params = getParameter(a)
        params = {'sigma0', num2str(a.sigma0), 'rho0', num2str(a.rho0), ...
            'alpha0', num2str(a.alpha0), 'adjGap', num2str(a.adjGap)};
    end

    function setParameter(a, params)
        a.sigma0 = str2double(params{1}); a.rho0 = str2double(params{2});
        a.alpha0 = str2double(params{3}); a.adjGap = str2double(params{4});
    end

    function reset(a)
        reset@StreamAlgorithm(a);
        a.DecisionLog = struct('Task', {}, 'Clock', {}, 'Generation', {}, ...
            'Sources', {}, 'SourceVersions', {}, 'SourceClocks', {}, ...
            'Transfer', {}, 'Probe', {}, 'Rho', {}, 'Alpha', {});
    end
end

methods (Access = protected)
    function onEvent(a, p, event, tasks)
        if strcmp(event, 'start')
            validateattributes(p.N, {'numeric'}, {'scalar','integer','>=',2,'finite'});
            validateattributes(a.sigma0, {'numeric'}, {'scalar','positive','finite'});
            validateattributes(a.rho0, {'numeric'}, {'scalar','>=',0,'<=',1,'finite'});
            validateattributes(a.alpha0, {'numeric'}, {'scalar','>=',0,'<=',1,'finite'});
            validateattributes(a.adjGap, {'numeric'}, {'scalar','integer','positive','finite'});
            a.Shared.Ready = false(1, p.T);
            a.Shared.Knowledge = cell(1, p.T);
            shape = max(0, log(p.N / 2 + 1) - log(1:p.N));
            a.Shared.Shape = shape / sum(shape) - 1 / p.N;
        elseif strcmp(event, 'arrival')
            for t = tasks
                x = [initESMean(p, t)'; rand(max(p.D) - p.D(t), 1)];
                S = a.sigma0 * initESSigmaScale(p, t) * ones(max(p.D), 1);
                s = struct('x', x, 'S', S, 'vx', x, 'vS', S, ...
                    'etaS', (3 + log(p.D(t))) / (5 * sqrt(p.D(t))), ...
                    'rho', a.rho0, 'alpha', a.alpha0, 'gen', 0, ...
                    'virtualReady', false, 'batch', [], 'offset', 0, ...
                    'Z', [], 'count', 0, 'probe', false);
                a.State{t} = s; a.Mean{t} = x';
            end
        end
    end

    function step(a, p, active)
        % Keep both samples and noise unchanged across arrival interruptions.
        pending = active(cellfun(@(s) ~isempty(s.batch), a.State(active)));
        if isempty(pending), t = active(1); else, t = pending(1); end
        s = a.State{t};
        if isempty(s.batch)
            remaining = p.TaskBudget(t) - a.TaskFE(t);
            s.count = min(p.N, remaining);
            s.Z = randn(max(p.D), s.count);
            X = s.x + s.S .* s.Z;
            % A probe is a full paired population, charged to the same task.
            s.probe = s.virtualReady && mod(s.gen + 1, a.adjGap) == 0 ...
                && remaining >= 2 * p.N;
            if s.probe, X = [X, s.vx + s.vS .* s.Z]; end
            pop(1, size(X, 2)) = Individual();
            for i = 1:numel(pop), pop(i).Dec = X(:, i)'; end
            s.batch = pop; s.offset = 0;
        end
        evaluated = a.Evaluation(s.batch(s.offset + 1:end), p, t);
        s.batch(s.offset + (1:numel(evaluated))) = evaluated;
        s.offset = s.offset + numel(evaluated);
        a.Population{t} = s.batch(1:min(s.offset, s.count));
        if s.offset == numel(s.batch)
            % A final short batch improves Best but cannot publish a gradient.
            if s.count == p.N
                s = a.updateDistribution(p, t, s);
                a.Mean{t} = s.x';
            end
            s.batch = []; s.offset = 0; s.Z = [];
        end
        a.State{t} = s;
    end

    function s = updateDistribution(a, p, t, s)
        sample = s.batch(1:p.N);
        order = RankWithBoundaryHandling(sample, p);
        weights = zeros(1, p.N); weights(order) = a.Shared.Shape;
        if s.probe
            virtual = s.batch(p.N + 1:end);
            fit = 1e8 * mean(sample.CVs) + mean(sample.Objs);
            vfit = 1e8 * mean(virtual.CVs) + mean(virtual.Objs);
            if vfit > fit
                s.rho = 2/3 * s.rho; s.alpha = 2/3 * s.alpha;
            else
                s.rho = min(1, 3/2 * s.rho);
                s.alpha = min(1, 3/2 * s.alpha);
            end
        end
        s.gen = s.gen + 1;
        gx = s.Z * weights'; gs = (s.Z.^2 - 1) * weights';
        % Publish only the local gradient, never the already transferred one.
        a.Shared.Knowledge{t} = struct('Gx', gx, 'GS', gs, ...
            'Version', s.gen, 'Clock', a.Clock, 'TaskFE', a.TaskFE(t));
        a.Shared.Ready(t) = true;
        [tagx, tags, ids] = a.taskGradient(p);
        versions = zeros(size(ids)); clocks = versions;
        for j = 1:numel(ids)
            k = a.Shared.Knowledge{ids(j)};
            versions(j) = k.Version; clocks(j) = k.Clock;
        end

        % Use local generations; a newly arriving task starts its own schedule.
        s.virtualReady = mod(s.gen + 1, a.adjGap) == 0;
        if s.virtualReady
            s.vx = s.x + s.S .* (gx + 3/2 * s.rho * tagx);
            s.vS = s.S .* exp(0.5 * s.etaS * (gs + 3/2 * s.rho * tags));
        end
        transfer = rand() < s.alpha || s.virtualReady;
        a.DecisionLog(end + 1) = struct('Task', t, 'Clock', a.Clock, ...
            'Generation', s.gen, 'Sources', ids, 'SourceVersions', versions, ...
            'SourceClocks', clocks, 'Transfer', transfer && ~isempty(ids), ...
            'Probe', s.probe, 'Rho', s.rho, 'Alpha', s.alpha);
        if transfer
            gx = gx + s.rho * tagx; gs = gs + s.rho * tags;
        end
        s.x = s.x + s.S .* gx;
        s.S = s.S .* exp(0.5 * s.etaS * gs);
    end

    function [gx, gs, ids] = taskGradient(a, p)
        % Recompute active at consumption time: completion events are dispatched
        % after step, so Completed alone would include a just-exhausted task.
        ids = find(a.Shared.Ready & a.Started & ~a.Completed ...
            & p.Arrival <= a.Clock & a.TaskFE < p.TaskBudget);
        gx = zeros(max(p.D), 1); gs = gx;
        for id = ids
            k = a.Shared.Knowledge{id};
            gx = gx + k.Gx; gs = gs + k.GS;
        end
        if ~isempty(ids), gx = gx / numel(ids); gs = gs / numel(ids); end
    end
end
end
