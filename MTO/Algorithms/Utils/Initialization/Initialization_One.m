function population = Initialization_One(Algo, Prob, t, Individual_Class, N)
%% Initialize and evaluate the population for One task
% Input: Algorithm, Problem, task_idx, Individual_Class
% Output: population

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

if nargin < 5
    N = Prob.N;
end

% Generate Random Population
maxD = max(Prob.D);
PopDec = rand(N, maxD); % Decision variables in [0,1]
population(1, N) = Individual_Class();
DecCell = num2cell(PopDec, 2);
[population.Dec] = deal(DecCell{:});

% Evaluate Initial Population
population = Algo.Evaluation(population, Prob, t);
end
