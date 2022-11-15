function result = HV(MTOData, varargin)
    % <Metric>

    % Hypervolume (HV)
    % The code implementation is referenced from PlatEMO(https://github.com/BIMK/PlatEMO).

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    Par_flag = false;
    if length(varargin) >= 1
        Par_flag = varargin{1};
    end

    result.Metric = 'Max';
    result.RowName = {};
    result.ColumnName = {};
    % Data for Table
    result.TableData = [];
    % Data for Converge Plot
    result.ConvergeData.X = [];
    result.ConvergeData.Y = [];
    % Data for Pareto Plot
    result.ParetoData.Obj = {};
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

    % Calculate HV
    row = 1;
    for prob = 1:length(MTOData.Problems)
        optimum = MTOData.Problems(prob).Optimum;
        for task = 1:MTOData.Problems(prob).T
            for algo = 1:length(MTOData.Algorithms)
                gen = size(MTOData.Results(prob, algo, 1).Obj{task}, 1);
                hv = zeros(MTOData.Reps, gen);
                BestObj = {};
                if Par_flag
                    parfor rep = 1:MTOData.Reps
                        for g = 1:gen
                            Obj = squeeze(MTOData.Results(prob, algo, rep).Obj{task}(g, :, :));
                            CV = squeeze(MTOData.Results(prob, algo, rep).CV(task, g, :));
                            BestObj{rep} = getBestObj(Obj, CV);
                            hv(rep, g) = getHV(BestObj{rep}, optimum{task});
                        end
                    end
                else
                    for rep = 1:MTOData.Reps
                        for g = 1:gen
                            Obj = squeeze(MTOData.Results(prob, algo, rep).Obj{task}(g, :, :));
                            CV = squeeze(MTOData.Results(prob, algo, rep).CV(task, g, :));
                            BestObj{rep} = getBestObj(Obj, CV);
                            hv(rep, g) = getHV(BestObj{rep}, optimum{task});
                        end
                    end
                end
                result.TableData(row, algo, :) = hv(:, end);
                result.ConvergeData.Y(row, algo, :) = mean(hv(:, :), 1);
                result.ConvergeData.X(row, algo, :) = [1:gen] ./ gen .* MTOData.Problems(prob).maxFE ./ MTOData.Problems(prob).T;

                [~, rank] = sort(hv(:, end));
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

function score = getHV(PopObj, optimum)
    if size(PopObj, 2) ~= size(optimum, 2)
        score = nan;
    else
        [N, M] = size(PopObj);
        fmin = min(min(PopObj, [], 1), zeros(1, M));
        fmax = max(optimum, [], 1);
        PopObj = (PopObj - repmat(fmin, N, 1)) ./ repmat((fmax - fmin) * 1.1, N, 1);
        PopObj(any(PopObj > 1, 2), :) = [];
        RefPoint = ones(1, M);
        if isempty(PopObj)
            score = 0;
        elseif M < 4
            % Calculate the exact HV value
            pl = sortrows(PopObj);
            S = {1, pl};
            for k = 1:M - 1
                S_ = {};
                for i = 1:size(S, 1)
                    Stemp = Slice(cell2mat(S(i, 2)), k, RefPoint);
                    for j = 1:size(Stemp, 1)
                        temp(1) = {cell2mat(Stemp(j, 1)) * cell2mat(S(i, 1))};
                        temp(2) = Stemp(j, 2);
                        S_ = Add(temp, S_);
                    end
                end
                S = S_;
            end
            score = 0;
            for i = 1:size(S, 1)
                p = Head(cell2mat(S(i, 2)));
                score = score + cell2mat(S(i, 1)) * abs(p(M) - RefPoint(M));
            end
        else
            % Estimate the HV value by Monte Carlo estimation
            SampleNum = 1e6;
            MaxValue = RefPoint;
            MinValue = min(PopObj, [], 1);
            Samples = unifrnd(repmat(MinValue, SampleNum, 1), repmat(MaxValue, SampleNum, 1));
            for i = 1:size(PopObj, 1)
                drawnow('limitrate');
                domi = true(size(Samples, 1), 1);
                m = 1;
                while m <= M && any(domi)
                    domi = domi & PopObj(i, m) <= Samples(:, m);
                    m = m + 1;
                end
                Samples(domi, :) = [];
            end
            score = prod(MaxValue - MinValue) * (1 - size(Samples, 1) / SampleNum);
        end
    end
end

function S = Slice(pl, k, RefPoint)
    p = Head(pl);
    pl = Tail(pl);
    ql = [];
    S = {};
    while ~isempty(pl)
        ql = Insert(p, k + 1, ql);
        p_ = Head(pl);
        cell_(1, 1) = {abs(p(k) - p_(k))};
        cell_(1, 2) = {ql};
        S = Add(cell_, S);
        p = p_;
        pl = Tail(pl);
    end
    ql = Insert(p, k + 1, ql);
    cell_(1, 1) = {abs(p(k) - RefPoint(k))};
    cell_(1, 2) = {ql};
    S = Add(cell_, S);
end

function ql = Insert(p, k, pl)
    flag1 = 0;
    flag2 = 0;
    ql = [];
    hp = Head(pl);
    while ~isempty(pl) && hp(k) < p(k)
        ql = [ql; hp];
        pl = Tail(pl);
        hp = Head(pl);
    end
    ql = [ql; p];
    m = length(p);
    while ~isempty(pl)
        q = Head(pl);
        for i = k:m
            if p(i) < q(i)
                flag1 = 1;
            else
                if p(i) > q(i)
                    flag2 = 1;
                end
            end
        end
        if ~(flag1 == 1 && flag2 == 0)
            ql = [ql; Head(pl)];
        end
        pl = Tail(pl);
    end
end

function p = Head(pl)
    if isempty(pl)
        p = [];
    else
        p = pl(1, :);
    end
end

function ql = Tail(pl)
    if size(pl, 1) < 2
        ql = [];
    else
        ql = pl(2:end, :);
    end
end

function S_ = Add(cell_, S)
    n = size(S, 1);
    m = 0;
    for k = 1:n
        if isequal(cell_(1, 2), S(k, 2))
            S(k, 1) = {cell2mat(S(k, 1)) + cell2mat(cell_(1, 1))};
            m = 1;
            break;
        end
    end
    if m == 0
        S(n + 1, :) = cell_(1, :);
    end
    S_ = S;
end
