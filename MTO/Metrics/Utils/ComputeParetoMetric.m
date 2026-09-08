function result = ComputeParetoMetric(data, metric, competitive, varargin)
% Shared front extraction and history evaluation for multi-objective metrics.
parallel = ~isempty(varargin) && varargin{1};
direction = 'Min';
if startsWith(metric, 'HV'), direction = 'Max'; end
relative = any(strcmp(metric, {'HV', 'Spread'}));
result = CreateMetricResult(data, direction, relative, ~competitive);
result.ConvergeData.X = [];
result.ConvergeData.Y = [];
result.ParetoData.Obj = {};
result.ParetoData.Optimum = [];
if any([data.Problems.M] <= 1), return; end
row = 1;
for p = 1:numel(data.Problems)
    problem = data.Problems(p);
    groups = num2cell(1:problem.T);
    if competitive, groups = {1:problem.T}; end
    for group = 1:numel(groups)
        tasks = groups{group};
        reference = vertcat(problem.Optimum{tasks});
        if competitive, reference = nondominated(reference); end
        evaluate = evaluator(data, p, tasks, metric, reference);
        for a = 1:numel(data.Algorithms)
            records = data.Results(p, a, :);
            histories = cell(1, data.Reps);
            fronts = cell(1, data.Reps);
            if parallel
                parfor r = 1:data.Reps
                    [histories{r}, fronts{r}] = evaluateHistory(records(r), tasks, evaluate);
                end
            else
                for r = 1:data.Reps
                    [histories{r}, fronts{r}] = evaluateHistory(records(r), tasks, evaluate);
                end
            end
            values = vertcat(histories{:});
            budget = problem.maxFE;
            if ~competitive, budget = budget / problem.T; end
            result = StoreMetricHistory(result, row, a, values, budget);
            result.ParetoData.Obj(row, a, 1:data.Reps) = reshape(fronts, 1, 1, []);
        end
        result.ParetoData.Optimum{row} = reference;
        row = row + 1;
    end
end
end

function evaluate = evaluator(data, problem, tasks, metric, reference)
switch metric
    case 'IGD', evaluate = @(front) getIGD(front, reference);
    case 'IGDp', evaluate = @(front) getIGDp(front, reference);
    case 'HV_RefPoint', evaluate = @(front) getHV(front, max(reference, [], 1));
    otherwise
        % Relative metrics derive their reference from all final feasible fronts.
        combined = [];
        for a = 1:numel(data.Algorithms)
            for t = tasks
                for r = 1:data.Reps
                    record = data.Results(problem, a, r);
                    combined = [combined; feasibleFront(record, t, size(record.CV, 2))];
                end
            end
        end
        combined = nondominated(combined);
        if strcmp(metric, 'Spread')
            evaluate = @(front) getSpread(front, combined);
        else
            if isempty(combined)
                objectives = size(data.Results(problem, 1, 1).Obj{tasks(1)}, 3);
                upper = ones(1, objectives);
                lower = zeros(1, objectives);
            else
                upper = max(combined, [], 1);
                lower = min(combined, [], 1);
            end
            evaluate = @(front) getHV(front, upper, lower);
        end
end
end

function [values, front] = evaluateHistory(record, tasks, evaluate)
count = size(record.CV, 2);
values = zeros(1, count);
for g = 1:count
    front = nondominated(feasibleFront(record, tasks, g));
    values(g) = evaluate(front);
end
end

function front = feasibleFront(record, tasks, generation)
parts = cell(1, numel(tasks));
for i = 1:numel(tasks)
    task = tasks(i);
    history = record.Obj{task};
    % Explicit dimensions also handle a population containing one individual.
    objectives = reshape(history(generation, :, :), size(history, 2), size(history, 3));
    violations = reshape(record.CV(task, generation, :), [], 1);
    parts{i} = objectives(violations <= 0, :);
end
front = vertcat(parts{:});
end

function front = nondominated(front)
if ~isempty(front), front = front(NDSort(front, 1) == 1, :); end
end
