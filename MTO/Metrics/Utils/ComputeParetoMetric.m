function result = ComputeParetoMetric(data, result, competitive, prepare, varargin)
% Shared front extraction and history evaluation for multi-objective metrics.
% prepare(data, problemIndex, tasks, reference) returns evaluate(front).
% The metric owns its reference selection, normalization, and score formula;
% competitive pools tasks and nondominates their combined optimum/fronts.
parallel = ~isempty(varargin) && varargin{1};
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
        if competitive, reference = NondominatedMetricFront(reference); end
        evaluate = prepare(data, p, tasks, reference);
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

function [values, front] = evaluateHistory(record, tasks, evaluate)
count = size(record.CV, 2);
values = zeros(1, count);
for g = 1:count
    front = NondominatedMetricFront(ReadFeasibleMetricFront(record, tasks, g));
    values(g) = evaluate(front);
end
end
