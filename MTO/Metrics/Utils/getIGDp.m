function score = getIGDp(PopObj, optimum)

% This code is copy from PlatEMO(https://github.com/BIMK/PlatEMO).
%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

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
