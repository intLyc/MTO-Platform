classdef AAEMTO < StreamAlgorithm
% <Stream-task> <Single-objective> <None>

%------------------------------- Reference --------------------------------
% @Article{Xu2022AEMTO,
%   author  = {Xu, Hao and Qin, A. K. and Xia, Siyu},
%   journal = {IEEE Transactions on Evolutionary Computation},
%   title   = {Evolutionary Multi-Task Optimization with Adaptive Knowledge Transfer},
%   year    = {2022},
%   number  = {2},
%   pages   = {290--303},
%   volume  = {26},
%   doi     = {10.1109/TEVC.2021.3107435},
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
    w = 0.3;
    tsf_lb = 0.05;
    tsf_ub = 0.7;
    F = 0.5;
    CR = 0.5;
    mu = 2;
    mum = 5;
end

methods
    function parameter = getParameter(Algo)
        parameter = {'w: The quality update coefficient', num2str(Algo.w), ...
                'tsf_lb:The lower bounds of the knowledge transfer probability', num2str(Algo.tsf_lb), ...
                'tsf_ub:The lower bounds of the knowledge transfer probability', num2str(Algo.tsf_ub), ...
                'F: Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Probability', num2str(Algo.CR), ...
                'mu: index of Simulated Binary Crossover', num2str(Algo.mu), ...
                'mum: index of polynomial mutation', num2str(Algo.mum)};
    end

    function Algo = setParameter(Algo, parameter_cell)
        count = 1;
        Algo.w = str2double(parameter_cell{count}); count = count + 1;
        Algo.tsf_lb = str2double(parameter_cell{count}); count = count + 1;
        Algo.tsf_ub = str2double(parameter_cell{count}); count = count + 1;
        Algo.F = str2double(parameter_cell{count}); count = count + 1;
        Algo.CR = str2double(parameter_cell{count}); count = count + 1;
        Algo.mu = str2double(parameter_cell{count}); count = count + 1;
        Algo.mum = str2double(parameter_cell{count});
    end

end

methods (Access = protected)
    function onEvent(Algo, Prob, event, tasks) %#ok<INUSD>
        if ~strcmp(event, 'start'), return; end
        assert(Prob.N >= 4, 'Stream population algorithms require N >= 4.');
        Algo.Shared.Ready = false(1, Prob.T);
        Algo.Shared.QSelect = zeros(Prob.T);
        Algo.Shared.PSelect = (ones(Prob.T) - eye(Prob.T)) / max(1, Prob.T - 1);
        Algo.Shared.QSelf = zeros(1, Prob.T); Algo.Shared.QOther = zeros(1, Prob.T);
        Algo.Shared.PTransfer = ones(1, Prob.T) * (0.05 + 0.7) / 2;
    end

    function step(Algo, Prob, active)
        t = active(1);
        if ~Algo.Shared.Ready(t)
            StreamInitializePopulation(Algo, Prob, t, @Individual_DE, true);
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
        parent = Algo.Population{t};
        context = struct('Transfer', false, 'Sources', zeros(1, Prob.N), 'Counts', zeros(1, Prob.T));
        if rand <= Algo.Shared.PTransfer(t) && ~isempty(donors)
            context.Transfer = true;
            weights = Algo.Shared.PSelect(t, donors); cumulative = cumsum(weights / sum(weights));
            % Sample with one shared random offset; a source may be selected more than once.
            a = rand; chosen = zeros(1, numel(donors));
            for i = 1:numel(donors)
                chosen(i) = donors(find(rem(a + i / (numel(donors) + 1), 1) <= cumulative, 1));
            end
            total = sum(Algo.Shared.PSelect(t, chosen)); n = context.Counts;
            for j = 1:Prob.T
                if j ~= t && any(chosen == j)
                    n(j) = round(sum(chosen == j) * Prob.N * Algo.Shared.PSelect(t, j) / total);
                end
            end
            % Allocate candidates by source weight and assign the rounding remainder to the final source.
            n(chosen(end)) = n(chosen(end)) - sum(n) + Prob.N;
            % Guard rounding overflow when many donors compete for very few slots.
            if any(n < 0)
                n = max(n, 0);
                while sum(n) > Prob.N, [~, j] = max(n); n(j) = n(j) - 1; end
            end
            K = parent;
            for j = 1:Prob.T
                % Author code resets the write index for each donor.
                for i = 1:n(j)
                    K(i) = Algo.Population{j}(StreamFitnessRoulette(Algo.Population{j}.Objs));
                end
            end
            batch = parent; k = 1;
            for j = 1:Prob.T
                for i = 1:n(j)
                    batch(k).Dec = DE_Crossover(K(k).Dec, parent(k).Dec, Algo.CR);
                    context.Sources(k) = j; k = k + 1;
                end
            end
            context.Counts = n;
        else
            for i = 1:Prob.N, parent(i).F = Algo.F; parent(i).CR = Algo.CR; end
            Algo.Population{t} = parent;
            batch = Algo.Generation_DE(parent);
        end
    end
    function acceptBatch(Algo, Prob, t, batch, context)
        parent = Algo.Population{t};
        if context.Transfer
            % Update source quality from offspring improvements over their corresponding parents.
            success = batch.Objs < parent(1:numel(batch)).Objs;
            for j = 1:Prob.T
                selected = context.Sources(1:numel(batch)) == j; count = sum(selected);
                if count > 0
                    Algo.Shared.QSelect(t, j) = Algo.w * Algo.Shared.QSelect(t, j) + ...
                        (1 - Algo.w) * sum(success(selected)) / count;
                end
            end
            pmin = 0.3 / max(1, Prob.T - 1);
            for j = [1:t - 1, t + 1:Prob.T]
                Algo.Shared.PSelect(t, j) = pmin + (1 - (Prob.T - 1) * pmin) * ...
                    Algo.Shared.QSelect(t, j) / (sum(Algo.Shared.QSelect(t, :)) + 0.001);
            end
        end
        combined = [batch, parent]; [~, order] = sort(combined.Objs);
        Algo.Population{t} = combined(order(1:Prob.N));
        % Count surviving offspring by decision-vector intersection and track self/transfer success separately.
        [~, ia] = intersect(Algo.Population{t}.Decs, batch.Decs, 'rows');
        if context.Transfer
            Algo.Shared.QOther(t) = Algo.w * Algo.Shared.QOther(t) + (1 - Algo.w) * numel(ia) / Prob.N;
        else
            Algo.Shared.QSelf(t) = Algo.w * Algo.Shared.QSelf(t) + (1 - Algo.w) * numel(ia) / Prob.N;
        end
        Algo.Shared.PTransfer(t) = Algo.tsf_lb + Algo.Shared.QOther(t) / ...
            (Algo.Shared.QOther(t) + Algo.Shared.QSelf(t) + 0.001) * (Algo.tsf_ub - Algo.tsf_lb);
    end
end

methods
    function offspring = Generation_DE(Algo, population)
        for i = 1:length(population)
            offspring(i) = population(i);
            A = randperm(length(population), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

            offspring(i).Dec = population(x1).Dec + population(i).F * (population(x2).Dec - population(x3).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, population(i).CR);

            rand_Dec = rand(1, length(offspring(i).Dec));
            offspring(i).Dec(offspring(i).Dec > 1) = rand_Dec(offspring(i).Dec > 1);
            offspring(i).Dec(offspring(i).Dec < 0) = rand_Dec(offspring(i).Dec < 0);
        end
    end

end
end
