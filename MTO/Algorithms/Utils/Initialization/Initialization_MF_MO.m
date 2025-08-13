function population = Initialization_MF_MO(Algo, Prob, Individual_Class)
%% Multifactorial-Multi-objective - Initialize and evaluate the population
% Input: Algorithm, Problem, Individual_Class
% Output: population

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

% Generate initial population
population = Individual_Class.empty();
for t = 1:Prob.T
    for i = 1:Prob.N
        pop_t(i) = Individual_Class();
        pop_t(i).Dec = rand(1, max(Prob.D));
    end
    pop_t = Algo.Evaluation(pop_t, Prob, t);
    for i = 1:length(pop_t)
        pop_t(i).MFFactor = t;
    end
    population = [population, pop_t];
end
end
