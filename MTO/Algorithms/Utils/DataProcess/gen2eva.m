function Result = gen2eva(Result_Gen, FE_Gen, maxGen)
%% Map the convergence from generation to evaluation
% Input: Result_Gen, FE_Gen, maxGen
% Output: Result

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

if size(Result_Gen, 2) <= maxGen
    maxGen = size(Result_Gen, 2);
end

Result = Result_Gen(:, 1:maxGen);
for k = 1:size(Result_Gen, 1)
    Gap = FE_Gen(end) ./ (maxGen);
    idx = 1;
    i = 1;
    while i <= length(FE_Gen)
        if FE_Gen(i) >= ((idx) * Gap)
            Result(k, idx) = Result_Gen(k, i);
            idx = idx + 1;
        else
            i = i + 1;
        end
        if idx > maxGen
            break;
        end
    end
    Result(k, 1) = Result_Gen(k, 1);
    Result(k, end) = Result_Gen(k, end);
    if idx < maxGen
        for x = idx:maxGen
            Result(k, x) = Result_Gen(k, end);
        end
    end
end
end
