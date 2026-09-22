function result = Obj_MTS(MTOData, varargin)
% <Multi-task/Many-task> <Single-objective> <None/Constrained>

%  Objective - Multi-task Score

%------------------------------- Reference --------------------------------
% @Article{Da2017CEC2017-MTSO,
%   author     = {Da, Bingshui and Ong, Yew-Soon and Feng, Liang and Qin, A Kai and Gupta, Abhishek and Zhu, Zexuan and Ting, Chuan-Kang and Tang, Ke and Yao, Xin},
%   journal    = {arXiv preprint arXiv:1706.03470},
%   title      = {Evolutionary Multitasking for Single-objective Continuous Optimization: Benchmark Problems, Performance Metric, and Baseline Results},
%   year       = {2017},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

base = ReadMetricResult(MTOData, 'Obj', varargin{:});
result = CreateMetricResult(MTOData, base.Metric, true, false);
result = AggregateTaskMetric(MTOData, base, result, @multiTaskScore, false);
end

function average = multiTaskScore(values)
% Standardize each task/checkpoint over all algorithms and repetitions,
% then average the standardized scores across tasks.
for t = 1:size(values, 1)
    for g = 1:size(values, 4)
        sample = values(t, :, :, g);
        center = mean(sample, 'all', 'omitnan');
        scale = std(sample, 0, 'all');
        if scale == 0
            values(t, :, :, g) = 0;
        else
            values(t, :, :, g) = (sample - center) ./ scale;
        end
    end
end
average = mean(values, 1);
end
