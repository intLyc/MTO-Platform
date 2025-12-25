function population = Initialization(Algo, Prob, Individual_Class, N)
%% Multi-task - Initialize and evaluate the population
% Input: Algorithm, Problem, Individual_Class
% Output: population

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

if nargin < 4
    N = Prob.N;
end

population = cell(1, Prob.T);
maxD = max(Prob.D);

for t = 1:Prob.T
    % Generate Random Population
    PopDec = rand(N, maxD); % Decision variables in [0,1]
    CurrentPop(1, N) = Individual_Class();
    DecCell = num2cell(PopDec, 2);
    [CurrentPop.Dec] = deal(DecCell{:});

    % Evaluate Initial Population
    population{t} = Algo.Evaluation(CurrentPop, Prob, t);
end
end
