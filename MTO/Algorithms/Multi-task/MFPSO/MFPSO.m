classdef MFPSO < Algorithm
    % <MT-SO> <None/Constrained>

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
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
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
        function Parameter = getParameter(obj)
            Parameter = {'RMP: Random Mating Probability', num2str(obj.RMP), ...
                        'maxW', num2str(obj.maxW), ...
                        'minW', num2str(obj.minW), ...
                        'C1', num2str(obj.C1), ...
                        'C2', num2str(obj.C2), ...
                        'C3', num2str(obj.C3)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.RMP = str2double(Parameter{i}); i = i + 1;
            obj.maxW = str2double(Parameter{i}); i = i + 1;
            obj.minW = str2double(Parameter{i}); i = i + 1;
            obj.C1 = str2double(Parameter{i}); i = i + 1;
            obj.C2 = str2double(Parameter{i}); i = i + 1;
            obj.C3 = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialize
            population = Initialization_MF(obj, Prob, Individual_MFPSO);

            % Initialize PSO parameter
            for i = 1:length(population)
                population(i).PBestDec = population(i).Dec;
                population(i).PBestObj = population(i).Obj;
                population(i).PBestCV = population(i).CV;
                population(i).V = 0;
            end

            while obj.notTerminated(Prob)
                W = obj.maxW - (obj.maxW - obj.minW) * obj.FE / Prob.maxFE;

                % Generation
                population = obj.Generation(population, W, obj.Best);
                % Evaluation
                population_temp = Individual_MFPSO.empty();
                for t = 1:Prob.T
                    population_t = population([population.MFFactor] == t);
                    population_t = obj.Evaluation(population_t, Prob, t);
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

        function population = Generation(obj, population, W, GBest)
            for i = 1:length(population)
                % Velocity update
                if rand() < obj.RMP
                    help_task = randperm(length(GBest), 2);
                    help_task(help_task == population(i).MFFactor) = [];
                    help_task = help_task(1);

                    population(i).V = W * population(i).V + ...
                        obj.C1 .* rand() .* (population(i).PBestDec - population(i).Dec) + ...
                        obj.C2 .* rand() .* (GBest{population(i).MFFactor}.Dec - population(i).Dec) + ...
                        obj.C3 .* rand() .* (GBest{help_task}.Dec - population(i).Dec);
                else
                    population(i).V = W * population(i).V + ...
                        obj.C1 .* rand() .* (population(i).PBestDec - population(i).Dec) + ...
                        obj.C2 .* rand() .* (GBest{population(i).MFFactor}.Dec - population(i).Dec);
                end

                % Position update
                population(i).Dec = population(i).Dec + population(i).V;

                population(i).Dec(population(i).Dec > 1) = 1;
                population(i).Dec(population(i).Dec < 0) = 0;
            end
        end
    end
end
