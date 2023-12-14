classdef MTV_DE < Algorithm
% <Single-task> <Single-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @article{MezuraMontes2007MTV-DE,
%   title     = {Multiple Trial Vectors in Differential Evolution for Engineering Design},
%   author    = {E. Mezura-Montes and C. A. Coello Coello and J. Velázquez-Reyes and L. Muñoz-Dávila},
%   journal   = {Engineering Optimization},
%   doi       = {10.1080/03052150701364022},
%   number    = {5},
%   pages     = {567-589},
%   publisher = {Taylor & Francis},
%   volume    = {39},
%   year      = {2007}
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
    CR = 0.9
    No = 5
    SR = 0.45
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'F: Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Probability', num2str(Algo.CR), ...
                'No: number of trial vectors', num2str(Algo.No), ...
                'SR: stochastic ranking rate', num2str(Algo.SR)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
        Algo.No = str2double(Parameter{i}); i = i + 1;
        Algo.SR = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual);

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                % Generation
                offspring_temp = Algo.Generation(population{t});
                % Evaluation
                offspring_temp = Algo.Evaluation(offspring_temp, Prob, t);
                % Pre Selection
                for i = 1:length(population{t})
                    idx = (i - 1) * Algo.No + (1:Algo.No);
                    [~, ~, best] = min_FP(offspring_temp(idx).Objs, offspring_temp(idx).CVs);
                    offspring(i) = offspring_temp(idx(best));
                end
                % Selection
                [~, replace] = Selection_Tournament(population{t}, offspring);
                replace_obj = population{t}.Objs > offspring.Objs;
                idx_sr = rand(1, length(population{t})) <= Algo.SR;
                replace(idx_sr) = replace_obj(idx_sr);
                population{t}(replace) = offspring(replace);
            end
        end
    end

    function offspring = Generation(Algo, population)
        for i = 1:length(population)
            j = (i - 1) * Algo.No;
            for k = 1:Algo.No
                offspring(j + k) = population(i);
                A = randperm(length(population), 4);
                A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

                offspring(j + k).Dec = population(x1).Dec + Algo.F * (population(x2).Dec - population(x3).Dec);
                offspring(j + k).Dec = DE_Crossover(offspring(j + k).Dec, population(i).Dec, Algo.CR);

                offspring(j + k).Dec(offspring(j + k).Dec > 1) = 1;
                offspring(j + k).Dec(offspring(j + k).Dec < 0) = 0;
            end
        end
    end
end
end
