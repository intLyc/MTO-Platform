classdef MFPSO < Algorithm
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
    maxW = 0.9
    minW = 0.4
    C1 = 0.2
    C2 = 0.2
    C3 = 0.2
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                'maxW', num2str(Algo.maxW), ...
                'minW', num2str(Algo.minW), ...
                'C1', num2str(Algo.C1), ...
                'C2', num2str(Algo.C2), ...
                'C3', num2str(Algo.C3)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.RMP = str2double(Parameter{i}); i = i + 1;
        Algo.maxW = str2double(Parameter{i}); i = i + 1;
        Algo.minW = str2double(Parameter{i}); i = i + 1;
        Algo.C1 = str2double(Parameter{i}); i = i + 1;
        Algo.C2 = str2double(Parameter{i}); i = i + 1;
        Algo.C3 = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization_MF(Algo, Prob, Individual_MFPSO);

        % Initialize PSO parameter
        for i = 1:length(population)
            population(i).PBestDec = population(i).Dec;
            population(i).PBestObj = population(i).Obj;
            population(i).PBestCV = population(i).CV;
            population(i).V = 0;
        end

        while Algo.notTerminated(Prob)
            W = Algo.maxW - (Algo.maxW - Algo.minW) * Algo.FE / Prob.maxFE;

            % Generation
            population = Algo.Generation(population, W, Algo.Best);
            % Evaluation
            population_temp = Individual_MFPSO.empty();
            for t = 1:Prob.T
                population_t = population([population.MFFactor] == t);
                population_t = Algo.Evaluation(population_t, Prob, t);
                population_temp = [population_temp, population_t];
            end
            population = population_temp;
            % PBest update
            for i = 1:length(population)
                if population(i).CV < population(i).PBestCV || ...
                        (population(i).CV == population(i).PBestCV && ...
                        population(i).Obj < population(i).PBestObj)
                    population(i).PBestDec = population(i).Dec;
                    population(i).PBestObj = population(i).Obj;
                    population(i).PBestCV = population(i).CV;
                end
            end
        end
    end

    function population = Generation(Algo, population, W, GBest)
        for i = 1:length(population)
            % Velocity update
            if rand() < Algo.RMP
                help_task = randperm(length(GBest), 2);
                help_task(help_task == population(i).MFFactor) = [];
                help_task = help_task(1);

                population(i).V = W * population(i).V + ...
                    Algo.C1 .* rand() .* (population(i).PBestDec - population(i).Dec) + ...
                    Algo.C2 .* rand() .* (GBest{population(i).MFFactor}.Dec - population(i).Dec) + ...
                    Algo.C3 .* rand() .* (GBest{help_task}.Dec - population(i).Dec);
            else
                population(i).V = W * population(i).V + ...
                    Algo.C1 .* rand() .* (population(i).PBestDec - population(i).Dec) + ...
                    Algo.C2 .* rand() .* (GBest{population(i).MFFactor}.Dec - population(i).Dec);
            end

            % Position update
            population(i).Dec = population(i).Dec + population(i).V;

            population(i).Dec(population(i).Dec > 1) = 1;
            population(i).Dec(population(i).Dec < 0) = 0;
        end
    end
end
end
