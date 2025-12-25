function population = Initialization_MF_One(Algo, Prob, Individual_Class)
%% Multifactorial - Initialize and evaluate the population One Times
% Input: Algorithm, Problem, Individual_Class
% Output: population

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

N = Prob.N;
T = Prob.T;
TotalN = N * T;
maxD = max(Prob.D);

population(1, TotalN) = Individual_Class();

InitVec = inf(1, T);
InitCell = repmat({InitVec}, 1, TotalN);
[population.MFObj] = deal(InitCell{:});
[population.MFCV] = deal(InitCell{:});

for t = 1:T
    idx_start = (t - 1) * N + 1;
    idx_end = t * N;
    pop_t = population(idx_start:idx_end);

    % Generate Random Decision Variables
    PopDec = rand(N, maxD); % Decision variables in [0,1]
    DecCell = num2cell(PopDec, 2);
    [pop_t.Dec] = deal(DecCell{:});

    % Evaluate Initial Sub-population for task t
    pop_t = Algo.Evaluation(pop_t, Prob, t);

    % Assign MFFactor
    [pop_t.MFFactor] = deal(t);

    % Update MFObj and MFCV for the current task t
    Objs = reshape([pop_t.Obj], length(pop_t(1).Obj), N)';
    CVs = [pop_t.CV]';

    CurrentObj = Objs(:, 1);
    CurrentCV = CVs;

    for k = 1:N
        pop_t(k).MFObj(t) = CurrentObj(k);
        pop_t(k).MFCV(t) = CurrentCV(k);
    end
    population(idx_start:idx_end) = pop_t;
end
end
