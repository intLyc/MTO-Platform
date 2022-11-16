function result = IGD_Plus(MTOData, varargin)
    % <Metric>

    % Inverted Generational Distance Plus (IGD+)
    % The code implementation is referenced from PlatEMO(https://github.com/BIMK/PlatEMO).

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
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
                result.ConvergeData.Y(row, algo, :) = mean(igdp(:, :), 1);
                result.ConvergeData.X(row, algo, :) = [1:gen] ./ gen .* MTOData.Problems(prob).maxFE ./ MTOData.Problems(prob).T;

                [~, rank] = sort(igdp(:, end));
                result.ParetoData.Obj{row, algo} = squeeze(BestObj{rank(ceil(end / 2))}(:, :));
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

function score = getIGDp(PopObj, optimum)
    if size(PopObj, 2) ~= size(optimum, 2)
        score = nan;
    else
        [Nr, M] = size(optimum);
        [N, ~] = size(PopObj);
        delta = zeros(Nr, 1);
        for i = 1:Nr
            delta(i) = min(sqrt(sum(max(PopObj - repmat(optimum(i, :), N, 1), zeros(N, M)).^2, 2)));
        end
        score = mean(delta);
    end
end
