classdef KR_AMTEA < StreamAlgorithm
% <Multi-task/Many-task> <Single-objective> <None> <Stream>

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

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

% Author-code transfer rules with a serial FE clock and per-task budgets.
% Unlike the author implementation, every initialization/probe evaluation counts.
% Pending batches survive arrival events; selection occurs after batch completion.

properties
    Operator = 'GA/DE'
    F = 0.5
    CR = 0.5
    mu = 2
    mum = 5
    pTransfer = 0.5
    min = 0.1
    Lb = 0.1
    Ub = 0.7
end

methods
    function p = getParameter(Algo)
        p = {'Operator (split with /)', Algo.Operator, 'F', num2str(Algo.F), ...
                'CR', num2str(Algo.CR), 'mu', num2str(Algo.mu), 'mum', num2str(Algo.mum), ...
                'pTransfer', num2str(Algo.pTransfer), 'min', num2str(Algo.min), ...
                'Lb', num2str(Algo.Lb), 'Ub', num2str(Algo.Ub)};
    end

    function Algo = setParameter(Algo, p)
        names = {'Operator', 'F', 'CR', 'mu', 'mum', 'pTransfer', 'min', 'Lb', 'Ub'};
        Algo.Operator = p{1};
        for i = 2:numel(p), Algo.(names{i}) = str2double(p{i}); end
    end
end

methods (Access = protected)
    function onEvent(Algo, Prob, event, tasks) %#ok<INUSD>
        if ~strcmp(event, 'start'), return; end
        operators = strsplit(Algo.Operator, '/');
        assert(Prob.N >= 4 && all(ismember(operators, {'DE', 'GA'})), ...
        'KR-AMTEA requires N >= 4 and operators GA and/or DE.');
        Algo.Shared.Operators = operators;
        % AAM stores transfer probabilities; HM stores transfer fractions for target/source pairs.
        Algo.Shared.AAM = (Algo.Lb + Algo.Ub) / 2 * (ones(Prob.T) - eye(Prob.T));
        Algo.Shared.HM = Algo.pTransfer * ones(Prob.T);
        Algo.Shared.Archive = repmat({Individual_DE.empty(1, 0)}, 1, Prob.T);
        op = KR_MTEA(); % Same GA/DE variation operators, without evaluation.
        op.mu = Algo.mu; op.mum = Algo.mum;
        Algo.Shared.Variation = op;
        Algo.Shared.PastTransfers = zeros(Prob.T);
        Algo.Shared.PresentTransfers = zeros(Prob.T);
    end

    function step(Algo, Prob, active)
        t = active(1);
        if isempty(Algo.State{t}) || Algo.State{t}.Stage < 4
            Algo.initializeTask(Prob, t);
            return;
        end
        s = Algo.State{t};
        parents = Algo.Population{t};
        if isempty(s.Batch)
            % option: 0 random rank, 1 closest cross-task match, 2 second-closest within-task match.
            source = t; option = 2;
            donors = sort(active(active ~= t));
            donors = donors(cellfun(@(x) ~isempty(x) && x.Stage == 4, Algo.State(donors)));
            if ~isempty(donors)
                k = donors(Algo.roulette(Algo.Shared.AAM(t, donors)));
                if rand < Algo.Shared.AAM(t, k), source = k; option = 1; end
            end
            if rand > 0.9, option = 0; end
            nTransfer = round(Algo.Shared.HM(t, source) * Prob.N);
            temp = parents(end:-1:1);
            mapped = KR_AMTEA_Map(Algo.Population{source}.Decs, parents.Decs, nTransfer, option);
            for i = 1:Prob.N
                if i <= nTransfer, temp(i) = parents(i); temp(i).Dec = mapped(i, :); end
                temp(i).F = Algo.F; temp(i).CR = Algo.CR;
            end
            operators = Algo.Shared.Operators;
            if strcmp(operators{mod(t - 1, numel(operators)) + 1}, 'DE')
                offspring = Algo.Shared.Variation.Generation_DE(temp);
            else
                offspring = Algo.Shared.Variation.Generation_GA(temp);
            end
            s.Batch = offspring(1:Prob.N); s.Offset = 0;
            s.Source = source; s.Option = option; s.Transfer = nTransfer;
        end
        % Retain unevaluated offspring in Batch when an arrival interrupts evaluation.
        evaluated = Algo.Evaluation(s.Batch(s.Offset + 1:end), Prob, t);
        s.Batch(s.Offset + (1:numel(evaluated))) = evaluated;
        s.Offset = s.Offset + numel(evaluated);
        if s.Offset < numel(s.Batch) && Algo.TaskFE(t) < Prob.TaskBudget(t)
            Algo.State{t} = s;
            return;
        end
        offspring = s.Batch(1:s.Offset);
        combined = [parents, offspring];
        [~, order] = sort(combined.Objs);
        Algo.Population{t} = combined(order(1:Prob.N));
        pop = Algo.Population{t}(end:-1:1);
        % Reversing the population gives better survivors larger indices for the HM update.
        [~, ia] = intersect(pop.Decs, offspring.Decs, 'rows');
        % Preserve the author's archive rule: replace leading slots with probability 0.3.
        for i = 1:numel(ia)
            if rand < 0.3, Algo.Shared.Archive{t}(i) = pop(ia(i)); end
        end
        hm = Algo.min + sum(ia) / (Prob.N / 2 * (Prob.N + 1)) * (0.5 - Algo.min);
        Algo.Shared.HM(t, s.Source) = hm;
        % Update AAM only for nonrandom cross-task transfer.
        if s.Source ~= t && s.Option ~= 0
            advantage = (hm - Algo.Shared.HM(t, t)) / (hm + Algo.Shared.HM(t, t));
            w = 0.1 + 0.8 * rand;
            value = Algo.Lb + w * (Algo.Shared.AAM(t, s.Source) - Algo.Lb) + ...
                (1 - w) * advantage * (Algo.Ub - Algo.Lb);
            if isnan(value), value = Algo.Lb; end
            Algo.Shared.AAM(t, s.Source) = min(Algo.Ub, max(Algo.Lb, value));
        end
        if s.Source ~= t
            Algo.Shared.PresentTransfers(t, s.Source) = ...
                Algo.Shared.PresentTransfers(t, s.Source) + s.Transfer;
        end
        s.Batch = Individual_DE.empty(1, 0); s.Offset = 0;
        Algo.State{t} = s;
    end
end

methods (Access = private)
    function initializeTask(Algo, Prob, t)
        if isempty(Algo.State{t})
            donors = find(~cellfun(@isempty, Algo.Shared.Archive));
            donors(donors == t) = [];
            % The initial arrival group is randomly initialized in the author code.
            if Prob.Arrival(t) == min(Prob.Arrival), donors = []; end
            % The author assumes few sources. Bound only the available slots.
            donors = donors(1:min(numel(donors), Prob.N));
            batch = repmat(Individual_DE(), 1, Prob.N);
            for i = 1:Prob.N, batch(i).Dec = rand(1, Prob.D(t)); end
            Algo.Population{t} = Individual_DE.empty(1, 0);
            Algo.State{t} = struct('Stage', 1, 'Offset', 0, 'Batch', batch, ...
                'Donors', donors, 'Source', t, 'Option', 2, 'Transfer', 0);
        end
        % Stage: 1 random evaluation, 2 source probes, 3 transfer reevaluation, 4 ready.
        s = Algo.State{t};
        if s.Stage == 1
            pop = Algo.Evaluation(s.Batch(s.Offset + 1:end), Prob, t);
            Algo.Population{t} = [Algo.Population{t}, pop];
            s.Offset = s.Offset + numel(pop);
            if s.Offset == Prob.N
                Algo.Shared.Archive{t} = Algo.Population{t};
                s.Offset = 0; s.Batch = Individual_DE.empty(1, 0);
                if isempty(s.Donors), s.Stage = 4; else, s.Stage = 2; end
            end
        elseif s.Stage == 2
            i = s.Offset + 1; source = s.Donors(i);
            % Sample without replacement unless the source has fewer dimensions.
            ids = randsample(Prob.D(source), Prob.D(t), Prob.D(source) < Prob.D(t));
            pop = Algo.Population{t}(i);
            pop.Dec = Algo.Population{source}(1).Dec(ids);
            Algo.Population{t}(i) = Algo.Evaluation(pop, Prob, t);
            Algo.Shared.PastTransfers(t, source) = Algo.Shared.PastTransfers(t, source) + 1;
            s.Offset = i;
            if i == numel(s.Donors)
                % Preserve the released code's loop bounds (including overwrite of slot L).
                for j = numel(s.Donors):round(Prob.N / 2) - numel(s.Donors)
                    scores = Algo.Population{t}(1:numel(s.Donors)).Objs;
                    weights = 1 ./ (scores - min(min(scores), 0) +1e-6);
                    source = s.Donors(Algo.roulette(weights));
                    ids = randsample(Prob.D(source), Prob.D(t), Prob.D(source) < Prob.D(t));
                    archive = Algo.Shared.Archive{source};
                    Algo.Population{t}(j).Dec = archive(randi(numel(archive))).Dec(ids);
                    Algo.Shared.PastTransfers(t, source) = Algo.Shared.PastTransfers(t, source) + 1;
                end
                s.Stage = 3; s.Offset = 0;
            end
        else
            pop = Algo.Evaluation(Algo.Population{t}(s.Offset + 1:end), Prob, t);
            Algo.Population{t}(s.Offset + (1:numel(pop))) = pop;
            s.Offset = s.Offset + numel(pop);
            if s.Offset == Prob.N
                Algo.Shared.Archive{t} = Algo.Population{t};
                s.Stage = 4; s.Offset = 0;
            end
        end
        Algo.State{t} = s;
    end
end

methods (Static, Access = private)
    function index = roulette(weights)
        cumulative = cumsum(weights(:));
        index = find(rand <= cumulative / cumulative(end), 1);
    end
end
end
