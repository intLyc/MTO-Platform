classdef JADE < Algorithm
    % <ST-SO> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Zhang2007JADE,
    %   author     = {Jingqiao Zhang and Sanderson, Arthur C.},
    %   booktitle  = {2007 IEEE Congress on Evolutionary Computation},
    %   title      = {Jade: Self-adaptive Differential Evolution with Fast and Reliable Convergence Performance},
    %   year       = {2007},
    %   pages      = {2251-2258},
    %   doi        = {10.1109/CEC.2007.4424751},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (C) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        P = 0.1
        C = 0.1
    end

    methods
        function Parameter = getParameter(Algo)
            Parameter = {'P: 100p% top as pbest', num2str(Algo.P), ...
                        'C: life span of uF and uCR', num2str(Algo.C)};
        end

        function Algo = setParameter(Algo, Parameter)
            i = 1;
            Algo.P = str2double(Parameter{i}); i = i + 1;
            Algo.C = str2double(Parameter{i}); i = i + 1;
        end

        function run(Algo, Prob)
            % Initialization
            population = Initialization(Algo, Prob, Individual_DE);
            for t = 1:Prob.T
                % initialize Parameter
                uF{t} = 0.5;
                uCR{t} = 0.5;
                archive{t} = Individual_DE.empty();
            end

            while Algo.notTerminated(Prob)
                for t = 1:Prob.T
                    % calculate individual F and CR
                    for i = 1:length(population{t})
                        population{t}(i).F = cauchyrnd(uF{t}, 0.1);
                        while (population{t}(i).F <= 0)
                            population{t}(i).F = cauchyrnd(uF{t}, 0.1);
                        end
                        population{t}(i).F(population{t}(i).F > 1) = 1;

                        population{t}(i).CR = normrnd(uCR{t}, 0.1);
                        population{t}(i).CR(population{t}(i).CR > 1) = 1;
                        population{t}(i).CR(population{t}(i).CR < 0) = 0;
                    end

                    union = [population{t}, archive{t}];
                    offspring = Algo.Generation(population{t}, union);
                    % Evaluation
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    % Selection
                    [~, replace] = Selection_Tournament(population{t}, offspring);

                    % calculate SF SCR
                    SF = [population{t}(replace).F];
                    SCR = [population{t}(replace).CR];

                    % update uF uCR
                    for i = 1:length(SF)
                        newSF = sum(SF.^2) ./ sum(SF);
                        uF{t} = (1 - Algo.C) * uF{t} + Algo.C .* newSF;
                        uCR{t} = (1 - Algo.C) * uCR{t} + Algo.C .* mean(SCR);
                    end

                    % Update archive
                    archive{t} = [archive{t}, population{t}(replace)];
                    if length(archive{t}) > length(population{t})
                        archive{t} = archive{t}(randperm(length(archive{t}), length(population{t})));
                    end

                    population{t}(replace) = offspring(replace);
                end
            end
        end

        function offspring = Generation(Algo, population, union)
            % get top 100p% individuals
            [~, rank] = sortrows([population.CVs, population.Objs], [1, 2]);
            pop_pbest = rank(1:max(round(Algo.P * length(population)), 1));

            for i = 1:length(population)
                offspring(i) = population(i);

                pbest = pop_pbest(randi(length(pop_pbest)));
                x1 = randi(length(population));
                while x1 == i || x1 == pbest
                    x1 = randi(length(population));
                end
                x2 = randi(length(union));
                while x2 == i || x2 == x1 || x2 == pbest
                    x2 = randi(length(union));
                end

                offspring(i).Dec = population(i).Dec + ...
                    population(i).F * (population(pbest).Dec - population(i).Dec) + ...
                    population(i).F * (population(x1).Dec - union(x2).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, population(i).CR);

                % offspring(i).Dec(offspring(i).Dec > 1) = 1;
                % offspring(i).Dec(offspring(i).Dec < 0) = 0;

                vio_low = find(offspring(i).Dec < 0);
                offspring(i).Dec(vio_low) = (population(i).Dec(vio_low) + 0) / 2;
                vio_up = find(offspring(i).Dec > 1);
                offspring(i).Dec(vio_up) = (population(i).Dec(vio_up) + 1) / 2;
            end
        end
    end
end
