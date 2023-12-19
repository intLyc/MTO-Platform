classdef MKTDE < Algorithm
% <Multi-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Li2021MKTDE,
%   title   = {A Meta-Knowledge Transfer-Based Differential Evolution for Multitask Optimization},
%   author  = {Li, Jian-Yu and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
%   journal = {IEEE Transactions on Evolutionary Computation},
%   year    = {2022},
%   number  = {4},
%   pages   = {719-734},
%   volume  = {26},
%   doi     = {10.1109/TEVC.2021.3131236},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    F = 0.5
    CR = 0.6
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'F: Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Rate', num2str(Algo.CR)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual);

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                centroid{t} = mean(population{t}.Decs, 1);
            end
            for t = 1:Prob.T
                % Source task selection
                s(t) = randi(Prob.T);
                while s(t) == t, s(t) = randi(Prob.T); end
                % Generation
                offspring = Algo.Generation(population{t}, population{s(t)}, centroid{t}, centroid{s(t)});
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                population{t} = Selection_Elit(population{t}, offspring);
            end
            for t = 1:Prob.T
                % Elite solution transfer
                population{t}(end) = population{s(t)}(1);
                population{t}(end) = Algo.Evaluation(population{t}(end), Prob, t);
            end
        end
    end

    function offspring = Generation(Algo, population, spop, ct, cs)
        popf_dec = [population.Decs; spop.Decs - cs + ct];
        for i = 1:length(population)
            offspring(i) = population(i);
            x1 = randi(length(population));
            while x1 == i, x1 = randi(length(population)); end
            x2 = randi(size(popf_dec, 1));
            while x2 == i || x2 == x1, x2 = randi(size(popf_dec, 1)); end
            x3 = randi(size(popf_dec, 1));
            while x3 == i || x3 == x2 || x3 == x1, x3 = randi(size(popf_dec, 1)); end

            offspring(i).Dec = population(x1).Dec + Algo.F * (popf_dec(x2, :) - popf_dec(x3, :));
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.CR);

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end
end
end
