function [Result, Index] = SampleResultByFE(generationResults, evaluationHistory, resultNum)
%% Sample generation results according to function evaluations
% Input: generationResults, evaluationHistory, resultNum
% Output: sampled results, selected generation indices

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

resultNum = max(1, round(resultNum));
generationNum = size(generationResults, 2);
if generationNum == 0
    Result = generationResults;
    Index = [];
    return;
end

if numel(evaluationHistory) < generationNum
    error('MToP:InvalidEvaluationHistory', ...
        'Evaluation history must contain one value for every recorded generation.');
end

if resultNum == 1
    Index = generationNum;
else
    Index = ones(1, resultNum);
    Index(end) = generationNum;
    gap = evaluationHistory(generationNum) / resultNum;
    for k = 2:resultNum - 1
        selected = find(evaluationHistory(1:generationNum) >= k * gap, ...
            1, 'first');
        if isempty(selected)
            selected = generationNum;
        end
        Index(k) = selected;
    end
end
Result = generationResults(:, Index);
end
