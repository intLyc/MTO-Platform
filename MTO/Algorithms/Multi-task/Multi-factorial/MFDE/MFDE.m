classdef MFDE < Algorithm
% <Multi-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Feng2017MFDE-MFPSO,
%   title      = {An Empirical Study of Multifactorial PSO and Multifactorial DE},
%   author     = {Feng, L. and Zhou, W. and Zhou, L. and Jiang, S. W. and Zhong, J. H. and Da, B. S. and Zhu, Z. X. and Wang, Y.},
%   booktitle  = {2017 IEEE Congress on Evolutionary Computation (CEC)},
%   year       = {2017},
%   pages      = {921-928},
%   doi        = {10.1109/CEC.2017.7969407},
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
    RMP = 0.3
    F = 0.5
    CR = 0.9
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                'F: Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Rate', num2str(Algo.CR)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.RMP = str2double(Parameter{i}); i = i + 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization_MF(Algo, Prob, Individual_MF);

        while Algo.notTerminated(Prob, population)
            % Generation
            offspring = Algo.Generation(population);
            % Evaluation
            offspring_temp = Individual_MF.empty();
            for t = 1:Prob.T
                offspring_t = offspring([offspring.MFFactor] == t);
                offspring_t = Algo.Evaluation(offspring_t, Prob, t);
                for i = 1:length(offspring_t)
                    offspring_t(i).MFObj = inf(1, Prob.T);
                    offspring_t(i).MFCV = inf(1, Prob.T);
                    offspring_t(i).MFObj(t) = offspring_t(i).Obj;
                    offspring_t(i).MFCV(t) = offspring_t(i).CV;
                end
                offspring_temp = [offspring_temp, offspring_t];
            end
            offspring = offspring_temp;
            % selection
            population = Selection_MF(population, offspring, Prob);
        end
    end

    function offspring = Generation(Algo, population)
        for i = 1:length(population)
            offspring(i) = population(i);

            x1 = randi(length(population));
            while x1 == i || population(x1).MFFactor ~= population(i).MFFactor
                x1 = randi(length(population));
            end
            if rand() < Algo.RMP
                x2 = randi(length(population));
                while population(x2).MFFactor == population(i).MFFactor
                    x2 = randi(length(population));
                end
                x3 = randi(length(population));
                while x3 == x2 || population(x3).MFFactor == population(i).MFFactor
                    x3 = randi(length(population));
                end
                MFFactors = [population([x1, x2, x3]).MFFactor];
                offspring(i).MFFactor = MFFactors(randi(3));
            else
                x2 = randi(length(population));
                while x2 == i || x2 == x1 || population(x2).MFFactor ~= population(i).MFFactor
                    x2 = randi(length(population));
                end
                x3 = randi(length(population));
                while x3 == i || x3 == x1 || x3 == x2 || population(x3).MFFactor ~= population(i).MFFactor
                    x3 = randi(length(population));
                end
                offspring(i).MFFactor = population(i).MFFactor;
            end

            offspring(i).Dec = population(x1).Dec + Algo.F * (population(x2).Dec - population(x3).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.CR);

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end
end
end
