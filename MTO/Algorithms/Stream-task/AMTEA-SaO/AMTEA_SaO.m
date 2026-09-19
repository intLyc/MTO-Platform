classdef AMTEA_SaO < StreamAlgorithm
% <Multi-task/Many-task> <Single-objective> <None/Constrained> <Stream>
% Author AMTO baseline adapted to StreamAlgorithm; all evaluations count.

%------------------------------- Reference --------------------------------
% @Article{Li2022MTEA-SaO,
%   title      = {Multitasking Optimization via an Adaptive Solver Multitasking Evolutionary Framework},
%   author     = {Yanchi Li and Wenyin Gong and Shuijia Li},
%   journal    = {Information Sciences},
%   year       = {2022},
%   issn       = {0020-0255},
%   doi        = {https://doi.org/10.1016/j.ins.2022.10.099},
%   url        = {https://www.sciencedirect.com/science/article/pii/S0020025522012191},
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
    % TGap, SaGap, and Memory use local FE; defaults equal 10, 70, and 30 generations at N=100.
    TGap = 1000
    TNum = 10
    SaGap = 7000
    Memory = 3000
    GA_MuC = 2
    GA_MuM = 5
    DE_F = 0.5
    DE_CR = 0.9
end

methods
    function parameter = getParameter(Algo)
        parameter = {'Transfer gap (FE per task)', num2str(Algo.TGap), ...
                'TNum: Transfer number', num2str(Algo.TNum), ...
                'Solver adaptation gap (FE per task)', num2str(Algo.SaGap), ...
                'Memory window (FE per task)', num2str(Algo.Memory), ...
                'MuC: GA Simulated Binary Crossover', num2str(Algo.GA_MuC), ...
                'MuM: GA Polynomial Mutation', num2str(Algo.GA_MuM), ...
                'F: DE Mutation Factor', num2str(Algo.DE_F), ...
                'CR: DE Crossover Probability', num2str(Algo.DE_CR)};
    end

    function Algo = setParameter(Algo, parameter_cell)
        count = 1;
        Algo.TGap = str2double(parameter_cell{count}); count = count + 1;
        Algo.TNum = str2double(parameter_cell{count}); count = count + 1;
        Algo.SaGap = str2double(parameter_cell{count}); count = count + 1;
        Algo.Memory = str2double(parameter_cell{count}); count = count + 1;
        Algo.GA_MuC = str2double(parameter_cell{count}); count = count + 1;
        Algo.GA_MuM = str2double(parameter_cell{count}); count = count + 1;
        Algo.DE_F = str2double(parameter_cell{count}); count = count + 1;
        Algo.DE_CR = str2double(parameter_cell{count}); count = count + 1;
    end

end

methods (Access = protected)
    function onEvent(Algo, Prob, event, tasks) %#ok<INUSD>
        if ~strcmp(event, 'start'), return; end
        assert(Prob.N >= 4, 'Stream population algorithms require N >= 4.');
        Algo.Shared.Ready = false(1, Prob.T);
        Algo.Shared.Sizes = repmat([fix(Prob.N / 2), Prob.N - fix(Prob.N / 2)], Prob.T, 1);
        Algo.Shared.Success = cell(1, Prob.T); Algo.Shared.Failure = cell(1, Prob.T);
        Algo.Shared.HistoryFE = cell(1, Prob.T);
    end

    function step(Algo, Prob, active)
        t = active(1);
        if ~Algo.Shared.Ready(t)
            StreamInitializePopulation(Algo, Prob, t, @Individual, true);
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
        parent = Algo.Population{t}; sizes = Algo.Shared.Sizes(t, :);
        context = struct('Sizes', sizes, 'Obj', median(parent.Objs), 'CV', median(parent.CVs));
        % Pause transfer in the final memory window to measure each solver's own performance.
        phase = mod(Algo.TaskFE(t), Algo.SaGap) + Prob.N;
        if Algo.TNum > 0 && phase < Algo.SaGap - Algo.Memory && ...
                StreamFECheckpoint(Algo.TaskFE(t), Prob.N, Algo.TGap) && ~isempty(donors)
            transfer = Algo.Transfer(Algo.Population(donors));
            transfer = transfer(1:min(numel(transfer), Prob.N));
            parent(randperm(Prob.N, numel(transfer))) = transfer;
        end
        % Place GA offspring before DE offspring and retain the split for selection.
        batch = Individual.empty();
        if sizes(1) > 0, batch = Algo.Generation_GA(parent(1:sizes(1))); end
        if sizes(2) > 0, batch = [batch, Algo.Generation_DE(parent(sizes(1) + 1:end))]; end
    end
    function acceptBatch(Algo, Prob, t, batch, context)
        ga = min(context.Sizes(1), numel(batch));
        if ga > 0
            idx = 1:context.Sizes(1);
            Algo.Population{t}(idx) = Selection_Elit(Algo.Population{t}(idx), batch(1:ga));
        end
        if numel(batch) > ga
            idx = context.Sizes(1) + (1:numel(batch) - ga);
            Algo.Population{t}(idx) = Selection_Tournament(Algo.Population{t}(idx), batch(ga + 1:end));
        end
        % Measure solver successes and failures against the pre-batch population medians.
        success = zeros(1, 2); failure = success;
        for st = 1:2
            idx = sum(context.Sizes(1:st - 1)) + (1:context.Sizes(st));
            p = Algo.Population{t}(idx);
            success(st) = sum(p.CVs < context.CV | (p.CVs == context.CV & p.Objs < context.Obj));
            failure(st) = sum(p.CVs > context.CV | (p.CVs == context.CV & p.Objs > context.Obj));
        end
        % Keep a separate Memory-FE history window for each task.
        fe = [Algo.Shared.HistoryFE{t}, Algo.TaskFE(t)];
        succ = [Algo.Shared.Success{t}; success]; fail = [Algo.Shared.Failure{t}; failure];
        keep = fe > Algo.TaskFE(t) - Algo.Memory;
        Algo.Shared.HistoryFE{t} = fe(keep);
        Algo.Shared.Success{t} = succ(keep, :); Algo.Shared.Failure{t} = fail(keep, :);
        if floor(Algo.TaskFE(t) / Algo.SaGap) > floor((Algo.TaskFE(t) - numel(batch)) / Algo.SaGap)
            s = sum(succ(keep, :), 1); f = sum(fail(keep, :), 1);
            % Combine success rates and previous proportions while keeping the total population at N.
            probability = s ./ max(s + f, 1) + 0.01 + context.Sizes / Prob.N / 2;
            sizes = fix(probability / sum(probability) * Prob.N);
            sizes(end) = Prob.N - sizes(1); Algo.Shared.Sizes(t, :) = sizes;
            Algo.Population{t} = Algo.Population{t}(randperm(Prob.N));
        end
    end
end

methods
    function transfer_pop = Transfer(Algo, archive)
        % random transfer
        for i = 1:Algo.TNum
            rand_t = randi([1, length(archive)]);
            rand_p = randi([1, length(archive{rand_t})]);
            transfer_pop(i) = archive{rand_t}(rand_p);
        end
    end

    function offspring = Generation_GA(Algo, population)
        if length(population) <= 1
            offspring = population;
            for i = 1:length(population)
                offspring(i).Dec = GA_Mutation(population(i).Dec, Algo.GA_MuM);
            end
            return;
        end
        indorder = randperm(length(population));
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(population) / 2));
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);

            [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.GA_MuC);

            offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.GA_MuM);
            offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.GA_MuM);

            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
        offspring = offspring(1:length(population));
    end

    function offspring = Generation_DE(Algo, population)
        if length(population) < 4
            offspring = population;
            for i = 1:length(population)
                offspring(i).Dec = GA_Mutation(population(i).Dec, Algo.GA_MuM);
            end
            return;
        end
        for i = 1:length(population)
            offspring(i) = population(i);
            A = randperm(length(population), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

            offspring(i).Dec = population(x1).Dec + Algo.DE_F * (population(x2).Dec - population(x3).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.DE_CR);

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end
end
end
