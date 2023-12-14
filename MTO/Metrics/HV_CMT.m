function result = HV_CMT(MTOData, varargin)
% <Metric> <Multi-objective>

% Competitive Hypervolume of All Tasks

%------------------------------- Reference --------------------------------
% @Article{Li2022CompetitiveMTO,
%   author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
%   journal    = {IEEE Transactions on Evolutionary Computation},
%   title      = {Evolutionary Competitive Multitasking Optimization},
%   year       = {2022},
%   pages      = {1-1},
%   doi        = {10.1109/TEVC.2022.3141819},
% }
%--------------------------------------------------------------------------

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

for prob = 1:length(MTOData.Problems)
    if MTOData.Problems(prob).M <= 1
        return;
    end
end
result.RowName = {MTOData.Problems.Name};
result.ColumnName = {MTOData.Algorithms.Name};

% Calculate Competitive HV
for prob = 1:length(MTOData.Problems)
    % Get Optimum
    AllBestObj = [];
    AllBestCV = [];
    for algo = 1:length(MTOData.Algorithms)
        for task = 1:MTOData.Problems(prob).T
            for rep = 1:MTOData.Reps
                AllBestObj = [AllBestObj; squeeze(MTOData.Results(prob, algo, rep).Obj{task}(end, :, :))];
                AllBestCV = [AllBestCV; squeeze(MTOData.Results(prob, algo, rep).CV(task, end, :))];
            end
        end
    end
    optimum = getBestObj(AllBestObj, AllBestCV);
    for algo = 1:length(MTOData.Algorithms)
        gen = size(MTOData.Results(prob, algo, 1).Obj{1}, 1);
        hv = zeros(MTOData.Reps, gen);
        BestObj = {};
        if Par_flag
            parfor rep = 1:MTOData.Reps
                for g = 1:gen
                    Obj = []; CV = [];
                    for task = 1:MTOData.Problems(prob).T
                        Obj_t = squeeze(MTOData.Results(prob, algo, rep).Obj{task}(g, :, :));
                        CV_t = squeeze(MTOData.Results(prob, algo, rep).CV(task, g, :));
                        Obj = [Obj; Obj_t];
                        CV = [CV; CV_t];
                    end
                    BestObj{rep} = getBestObj(Obj, CV);
                    hv(rep, g) = getHV(BestObj{rep}, optimum);
                end
            end
        else
            for rep = 1:MTOData.Reps
                for g = 1:gen
                    Obj = []; CV = [];
                    for task = 1:MTOData.Problems(prob).T
                        Obj_t = squeeze(MTOData.Results(prob, algo, rep).Obj{task}(g, :, :));
                        CV_t = squeeze(MTOData.Results(prob, algo, rep).CV(task, g, :));
                        Obj = [Obj; Obj_t];
                        CV = [CV; CV_t];
                    end
                    BestObj{rep} = getBestObj(Obj, CV);
                    hv(rep, g) = getHV(BestObj{rep}, optimum);
                end
            end
        end
        result.TableData(prob, algo, :) = hv(:, end);
        for rep = 1:MTOData.Reps
            result.ConvergeData.Y(prob, algo, rep, :) = hv(rep, :);
            result.ConvergeData.X(prob, algo, rep, :) = [1:gen] ./ gen .* MTOData.Problems(prob).maxFE;
            result.ParetoData.Obj{prob, algo, rep} = squeeze(BestObj{rep}(:, :));
        end
        result.ParetoData.Optimum{prob}(:, :) = optimum;
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
