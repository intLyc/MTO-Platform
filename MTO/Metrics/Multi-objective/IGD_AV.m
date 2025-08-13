function result = IGD_AV(MTOData, varargin)
% <Metric> <Multi-objective> <None/Constrained>

% Inverted Generational Distance (IGD) - Average Value for all task

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

for prob = 1:length(MTOData.Problems)
    if MTOData.Problems(prob).M <= 1
        return;
    end
end
result.RowName = {MTOData.Problems.Name};
result.ColumnName = {MTOData.Algorithms.Name};

if isfield(MTOData, 'Metrics')
    idx = find(strcmp({MTOData.Metrics.Name}, 'IGD'));
    if ~isempty(idx)
        igd_result = MTOData.Metrics(idx).Result;
    else
        igd_result = IGD(MTOData, Par_flag);
    end
else
    igd_result = IGD(MTOData, Par_flag);
end

% Calculate IGD-AV
row = 1;
algo = length(MTOData.Algorithms);
rep = MTOData.Reps;
gen = size(MTOData.Results(1, 1, 1).Obj{1}, 1);
for prob = 1:length(MTOData.Problems)
    result.ConvergeData.Y(prob, 1:algo, 1:rep, 1:gen) = mean(igd_result.ConvergeData.Y(row:row + MTOData.Problems(prob).T - 1, 1:algo, 1:rep, 1:gen), 1);
    result.ConvergeData.X(prob, 1:algo, 1:rep, 1:gen) = igd_result.ConvergeData.X(row, 1:algo, 1:rep, 1:gen) * MTOData.Problems(prob).T;
    result.TableData(prob, 1:algo, 1:rep) = mean(igd_result.TableData(row:row + MTOData.Problems(prob).T - 1, 1:algo, 1:rep), 1);
    row = row + MTOData.Problems(prob).T;
end
end
