function result = Obj_NBR(MTOData, varargin)
% <Multi-task/Many-task> <Single-objective> <None/Constrained>

% Number of Best Results for All Tasks - Objective

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

result = CreateMetricResult(MTOData, 'Max', true, false);
objective = ReadFinalMetricData(MTOData, @finalObjective);
if isempty(objective), return; end
means = mean(objective, 3, 'omitnan');
row = 1;
for p = 1:numel(MTOData.Problems)
    tasks = row:row + MTOData.Problems(p).T - 1;
    values = means(tasks, :);
    % Count every tied best algorithm; tasks with no feasible result contribute zero.
    result.TableData(p, :) = sum(values == min(values, [], 2), 1);
    row = row + MTOData.Problems(p).T;
end
end

function values = finalObjective(record)
values = record.Obj(:, end);
values(record.CV(:, end) > 0) = NaN;
end
