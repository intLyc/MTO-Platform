function result = Obj_CMT(MTOData, varargin)
% <Metric> <Single-objective>

% Minimum Objective Value of All Tasks (for Competitive Multitasking Optimization)

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

result.Metric = 'Min';
result.RowName = {};
result.ColumnName = {};
% Data for Table
result.TableData = [];
% Data for Converge Plot
result.ConvergeData.X = [];
result.ConvergeData.Y = [];

for prob = 1:length(MTOData.Problems)
    if MTOData.Problems(prob).M ~= 1
        return;
    end
end
result.RowName = {MTOData.Problems.Name};
result.ColumnName = {MTOData.Algorithms.Name};

% Calculate Minimal Objective
for prob = 1:length(MTOData.Problems)
    for algo = 1:length(MTOData.Algorithms)
        gen = size(MTOData.Results(prob, algo, 1).Obj, 2);
        MinObj = zeros(MTOData.Reps, gen);
        for rep = 1:MTOData.Reps
            Obj_temp = []; CV_temp = [];
            Obj_temp(1:MTOData.Problems(prob).T, 1:gen) = MTOData.Results(prob, algo, rep).Obj(1:MTOData.Problems(prob).T, 1:gen);
            CV_temp(1:MTOData.Problems(prob).T, 1:gen) = MTOData.Results(prob, algo, rep).CV(1:MTOData.Problems(prob).T, 1:gen);
            Obj_temp(CV_temp > 0) = NaN;
            MinObj(rep, 1:gen) = min(Obj_temp, [], 1);
        end
        result.TableData(prob, algo, 1:MTOData.Reps) = MinObj(1:MTOData.Reps, end);
        for rep = 1:MTOData.Reps
            result.ConvergeData.Y(prob, algo, rep, 1:gen) = MinObj(rep, 1:gen);
            result.ConvergeData.X(prob, algo, rep, 1:gen) = [1:gen] ./ gen .* MTOData.Problems(prob).maxFE;
        end
    end
end
end
