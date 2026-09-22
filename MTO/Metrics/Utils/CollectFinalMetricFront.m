function front = CollectFinalMetricFront(data, problem, tasks)
% Pool final feasible fronts over algorithms, tasks, and repetitions, in order.
front = [];
for a = 1:numel(data.Algorithms)
    for t = tasks
        for r = 1:data.Reps
            record = data.Results(problem, a, r);
            front = [front; ReadFeasibleMetricFront(record, t, size(record.CV, 2))];
        end
    end
end
front = NondominatedMetricFront(front);
end
