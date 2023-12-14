function result = IGDp(MTOData, varargin)
% <Metric> <Multi-objective>

% Inverted Generational Distance Plus (IGD+)

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

Par_flag = false;
if length(varargin) >= 1
    % Parallel Calculate
    Par_flag = varargin{1};
end

result.Metric = 'Min';
result.RowName = {};
result.ColumnName = {};
% Data for Table
result.TableData = [];
% Data for Converge Plot
result.ConvergeData.X = [];
result.ConvergeData.Y = [];
% Data for Pareto Plot
result.ParetoData.Obj = [];
result.ParetoData.Optimum = [];

row = 1;
for prob = 1:length(MTOData.Problems)
    if MTOData.Problems(prob).M <= 1
        return;
    end
    tnum = MTOData.Problems(prob).T;
    for task = 1:tnum
        if tnum == 1
            result.RowName{row} = MTOData.Problems(prob).Name;
        else
            result.RowName{row} = [MTOData.Problems(prob).Name, '-T', num2str(task)];
        end
        row = row + 1;
    end
end
result.ColumnName = {MTOData.Algorithms.Name};

% Calculate IGD+
row = 1;
for prob = 1:length(MTOData.Problems)
    optimum = MTOData.Problems(prob).Optimum;
    for task = 1:MTOData.Problems(prob).T
        for algo = 1:length(MTOData.Algorithms)
            gen = size(MTOData.Results(prob, algo, 1).Obj{task}, 1);
            igdp = zeros(MTOData.Reps, gen);
            BestObj = {};
            if Par_flag
                parfor rep = 1:MTOData.Reps
                    for g = 1:gen
                        Obj = squeeze(MTOData.Results(prob, algo, rep).Obj{task}(g, :, :));
                        CV = squeeze(MTOData.Results(prob, algo, rep).CV(task, g, :));
                        BestObj{rep} = getBestObj(Obj, CV);
                        igdp(rep, g) = getIGDp(BestObj{rep}, optimum{task});
                    end
                end
            else
                for rep = 1:MTOData.Reps
                    for g = 1:gen
                        Obj = squeeze(MTOData.Results(prob, algo, rep).Obj{task}(g, :, :));
                        CV = squeeze(MTOData.Results(prob, algo, rep).CV(task, g, :));
                        BestObj{rep} = getBestObj(Obj, CV);
                        igdp(rep, g) = getIGDp(BestObj{rep}, optimum{task});
                    end
                end
            end
            result.TableData(row, algo, :) = igdp(:, end);
            for rep = 1:MTOData.Reps
                result.ConvergeData.Y(row, algo, rep, :) = igdp(rep, :);
                result.ConvergeData.X(row, algo, rep, :) = [1:gen] ./ gen .* MTOData.Problems(prob).maxFE ./ MTOData.Problems(prob).T;
                result.ParetoData.Obj{row, algo, rep} = squeeze(BestObj{rep}(:, :));
            end
        end
        result.ParetoData.Optimum{row}(:, :) = optimum{task};
        row = row + 1;
    end
end
end

function BestObj = getBestObj(Obj, CV)
Feasible = find(all(CV <= 0, 2));
if isempty(Feasible)
    Best = [];
else
    Best = NDSort(Obj(Feasible, :), 1) == 1;
end
BestObj = Obj(Feasible(Best), :);
end
