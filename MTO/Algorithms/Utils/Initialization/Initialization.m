function population = Initialization(Algo, Prob, Individual_Class, varargin)
%% Multi-task - Initialize and evaluate the population
% Input: Algorithm, Problem, Individual_Class
% Output: population

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

n = numel(varargin);
if n == 0
    N = Prob.N;
elseif n == 1
    N = varargin{1};
else
    return;
end

for t = 1:Prob.T
    for i = 1:N
        population{t}(i) = Individual_Class();
        % switch gene_type
        % case 'unified'
        population{t}(i).Dec = rand(1, max(Prob.D));
        % case 'real'
        % population{t}(i).Dec = (Prob.Ub{t} - Prob.Lb{t}) .* rand(1, max(Prob.D)) + Prob.Lb{t};
        % end
    end
    population{t} = Algo.Evaluation(population{t}, Prob, t);
end
end
