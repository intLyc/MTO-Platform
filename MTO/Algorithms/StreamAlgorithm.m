classdef (Abstract) StreamAlgorithm < Algorithm
% Stream lifecycle and FE accounting; implement step and optionally onEvent.

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

properties
    % Clock includes idle jumps; the inherited FE counter counts actual evaluations only.
    Clock = 0
    % TaskFE, Population, and State retain slots for every original task ID.
    TaskFE = []
    Population = {} % Always indexed by original task ID
    State = {} % Per-task algorithm state
    Shared = struct() % Shared model, memory, or other cross-task state
    StreamLog = struct([])
    TaskHistory = {} % Best solutions indexed by each task's own evaluation count
end

properties (Access = protected)
    Started = []
    Completed = []
    LastTask = 0
end

methods
    function drawInit(Algo, Prob)
        if Algo.Draw_Dec
            Algo.dpd = StreamDrawPopDec(Algo, Prob);
        end
    end

    function reset(Algo)
        reset@Algorithm(Algo);
        Algo.Clock = 0;
        Algo.TaskFE = [];
        Algo.Population = {};
        Algo.State = {};
        Algo.Shared = struct();
        Algo.TaskHistory = {};
        Algo.Mean = {};
        Algo.Started = [];
        Algo.Completed = [];
        Algo.LastTask = 0;
        Algo.StreamLog = struct('Time', {}, 'FE', {}, 'Event', {}, ...
            'Task', {}, 'TaskFE', {}, 'Active', {}, 'BestObj', {});
    end

    function run(Algo, Prob)
        assert(max(Prob.M) == 1 && ~Prob.ReEvalBest, ...
        'StreamAlgorithm requires single-objective tasks and ReEvalBest=false.');
        Algo.reset();
        Algo.TaskFE = zeros(1, Prob.T);
        Algo.Started = false(1, Prob.T);
        Algo.Completed = false(1, Prob.T);
        Algo.State = cell(1, Prob.T);
        Algo.TaskHistory = repmat({struct('FE', {}, 'Obj', {}, 'CV', {}, 'Dec', {})}, 1, Prob.T);
        Algo.Mean = cell(1, Prob.T);
        Algo.Population = repmat({Individual.empty(1, 0)}, 1, Prob.T);
        % Placeholder best solutions keep all task slots available to notTerminated.
        missing = Individual();
        missing.Dec = nan(1, max(Prob.D));
        missing.Obj = NaN;
        missing.Con = Inf;
        missing.CV = Inf;
        Algo.Best = repmat({missing}, 1, Prob.T);
        Algo.dispatchEvent(Prob, 'start', []);

        while Algo.notTerminated(Prob, Algo.Population)
            if ~any(Prob.Arrival <= Algo.Clock & Algo.TaskFE < Prob.TaskBudget)
                % Skip idle intervals without consuming evaluation budgets.
                Algo.Clock = min(Prob.Arrival(~Algo.Started));
                Algo.dispatchEvent(Prob, 'idle-end', []);
            end
            arriving = find(~Algo.Started & Prob.Arrival <= Algo.Clock);
            Algo.Started(arriving) = true;
            if ~isempty(arriving), Algo.dispatchEvent(Prob, 'arrival', arriving); end

            active = find(Algo.Started & ~Algo.Completed);
            % Rotate active tasks so lower task IDs do not always run first.
            active = [active(active > Algo.LastTask), active(active <= Algo.LastTask)];
            before = Algo.FE;
            Algo.step(Prob, active);
            assert(Algo.FE > before, 'step must perform at least one evaluation.');
            finished = find(Algo.Started & ~Algo.Completed & Algo.TaskFE >= Prob.TaskBudget);
            Algo.Completed(finished) = true;
            if ~isempty(finished), Algo.dispatchEvent(Prob, 'complete', finished); end
        end
        Algo.dispatchEvent(Prob, 'finish', []);
    end

    function n = remainingFE(Algo, Prob, t)
        % Zero means unavailable, or an event must be handled before more work.
        % Dispatch pending arrival and completion events before allowing more evaluations.
        pending = any(~Algo.Started & Prob.Arrival <= Algo.Clock) || ...
            any(Algo.Started & ~Algo.Completed & Algo.TaskFE >= Prob.TaskBudget);
        n = 0;
        if ~Algo.Started(t) || Algo.Completed(t) || pending, return; end
        % Bound evaluations by the task budget, total budget, and next arrival.
        n = min(Prob.TaskBudget(t) - Algo.TaskFE(t), Prob.maxFE - Algo.FE);
        future = Prob.Arrival(~Algo.Started);
        if ~isempty(future), n = min(n, min(future) - Algo.Clock); end
    end

    function [pop, flag] = Evaluation(Algo, pop, Prob, t)
        % All objective calls, including transfer/meta-learning, use this entry.
        n = min(numel(pop), Algo.remainingFE(Prob, t));
        pop = pop(1:n);
        flag = false;
        if n == 0, return; end
        [pop, flag] = Evaluation@Algorithm(Algo, pop, Prob, t);
        % All evaluations, including transfer probes, advance task FE, total FE, and the clock.
        Algo.TaskFE(t) = Algo.TaskFE(t) + n;
        Algo.Clock = Algo.Clock + n;
        Algo.LastTask = t;
        best = Algo.Best{t};
        dec = [];
        if Algo.Save_Dec, dec = best.Dec; end
        Algo.TaskHistory{t}(end + 1) = struct('FE', Algo.TaskFE(t), ...
            'Obj', best.Obj, 'CV', best.CV, 'Dec', dec);
        Algo.logEvent(Prob, 'evaluate', t);
    end

    function Result = getResult(Algo, Prob)
        % Obj uses maxFE/T on the x-axis; sample local task FE to remove leading gaps.
        count = max(1, round(Algo.Result_Num));
        blank = struct('Obj', NaN, 'CV', Inf, 'Dec', nan(1, max(Prob.D)));
        Result = repmat(blank, Prob.T, count);
        for t = 1:Prob.T
            history = Algo.TaskHistory{t};
            if isempty(history), continue; end
            row = SampleResultByFE(history, [history.FE], count);
            row = rmfield(row, 'FE');
            if Algo.Save_Dec
                for k = 1:count
                    x = Prob.Lb{t} + row(k).Dec(1:Prob.D(t)) .* (Prob.Ub{t} - Prob.Lb{t});
                    % Pad results to the maximum task dimension with NaN.
                    row(k).Dec = nan(1, max(Prob.D));
                    row(k).Dec(1:Prob.D(t)) = x;
                end
            end
            Result(t, :) = row;
        end
        if ~Algo.Save_Dec, Result = rmfield(Result, 'Dec'); end
    end
end

methods (Access = protected)
    function onEvent(Algo, Prob, event, tasks) %#ok<INUSD>
        % Optional: start / arrival / complete / idle-end / finish.
        % Update state here; objective evaluations belong in step.
    end
end

methods (Abstract, Access = protected)
    step(Algo, Prob, active) % Evaluate and update any available tasks.
end

methods (Access = private)
    function dispatchEvent(Algo, Prob, event, tasks)
        Algo.onEvent(Prob, event, tasks);
        if isempty(tasks), tasks = 0; end
        for t = tasks
            Algo.logEvent(Prob, event, t);
        end
    end

    function logEvent(Algo, Prob, event, task)
        Algo.StreamLog(end + 1) = struct('Time', Algo.Clock, 'FE', Algo.FE, ...
            'Event', event, 'Task', task, 'TaskFE', Algo.TaskFE, ...
            'Active', Prob.Arrival <= Algo.Clock & Algo.TaskFE < Prob.TaskBudget, ...
            'BestObj', cellfun(@(p) p.Obj, Algo.Best));
    end
end
end
