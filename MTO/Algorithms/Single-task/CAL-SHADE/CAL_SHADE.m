classdef CAL_SHADE < Algorithm
    % <Single-task> <Single-objective> <Constrained>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Zamuda2017CAL-SHADE,
    %   title     = {Adaptive Constraint Handling and Success History Differential Evolution for Cec 2017 Constrained Real-Parameter Optimization},
    %   author    = {Zamuda, Aleš},
    %   booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %   year      = {2017},
    %   pages     = {2443-2450},
    %   doi       = {10.1109/CEC.2017.7969601},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        P = 0.2
        H = 10
        EC_Top = 0.2
        EC_Tc = 0.8
        EC_Cp = 5
    end

    methods
        function Parameter = getParameter(Algo)
            Parameter = {'P: 100p% top as pbest', num2str(Algo.P), ...
                        'H: success memory size', num2str(Algo.H), ...
                        'EC_Top', num2str(Algo.EC_Top), ...
                        'EC_Tc', num2str(Algo.EC_Tc), ...
                        'EC_Cp', num2str(Algo.EC_Cp)};
        end

        function Algo = setParameter(Algo, Parameter)
            i = 1;
            Algo.P = str2double(Parameter{i}); i = i + 1;
            Algo.H = str2double(Parameter{i}); i = i + 1;
            Algo.EC_Top = str2double(Parameter{i}); i = i + 1;
            Algo.EC_Tc = str2double(Parameter{i}); i = i + 1;
            Algo.EC_Cp = str2double(Parameter{i}); i = i + 1;
        end

        function run(Algo, Prob)
            % Initialization
            population = Initialization(Algo, Prob, Individual_DE);
            Nmin = 4;
            for t = 1:Prob.T
                % initialize Parameter
                n = ceil(Algo.EC_Top * length(population{t}));
                cv_temp = [population{t}.CV];
                [~, idx] = sort(cv_temp);
                Ep0{t} = cv_temp(idx(n));
                Hidx{t} = 1;
                MF{t} = 0.5 .* ones(Algo.H, 1);
                MCR{t} = 0.5 .* ones(Algo.H, 1);
                archive{t} = Individual_DE.empty();
            end

            while Algo.notTerminated(Prob)
                N = round((Nmin - Prob.N) / Prob.maxFE * Algo.FE + Prob.N);
                for t = 1:Prob.T
                    % Calculate individual F and CR
                    for i = 1:length(population{t})
                        idx = randi(Algo.H);
                        uF = MF{t}(idx);
                        population{t}(i).F = uF + 0.1 * tan(pi * (rand() - 0.5));
                        while (population{t}(i).F <= 0)
                            population{t}(i).F = uF + 0.1 * tan(pi * (rand() - 0.5));
                        end
                        population{t}(i).F(population{t}(i).F > 1) = 1;

                        uCR = MCR{t}(idx);
                        population{t}(i).CR = normrnd(uCR, 0.1);
                        population{t}(i).CR(population{t}(i).CR > 1) = 1;
                        population{t}(i).CR(population{t}(i).CR < 0) = 0;
                    end

                    % calculate epsilon
                    if Algo.FE < Algo.EC_Tc * Prob.maxFE
                        Ep = Ep0{t} * ((1 - Algo.FE / (Algo.EC_Tc * Prob.maxFE))^Algo.EC_Cp);
                    else
                        Ep = 0;
                    end

                    % Generation
                    union = [population{t}, archive{t}];
                    offspring = Algo.Generation(population{t}, union, Ep);
                    % Evaluation
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    % Selection
                    [~, replace] = Selection_Tournament(population{t}, offspring, Ep);

                    % calculate SF SCR
                    SF = [population{t}(replace).F];
                    SCR = [population{t}(replace).CR];
                    dif = population{t}(replace).CVs' - offspring(replace).CVs';
                    dif_obj = population{t}(replace).Objs' - offspring(replace).Objs';
                    dif_obj(dif_obj < 0) = 0;
                    dif(dif <= 0) = dif_obj(dif <= 0);
                    dif = dif ./ sum(dif);
                    % update MF MCR
                    if ~isempty(SF)
                        MF{t}(Hidx{t}) = sum(dif .* (SF.^2)) / sum(dif .* SF);
                        MCR{t}(Hidx{t}) = sum(dif .* SCR);
                    else
                        MF{t}(Hidx{t}) = MF{t}(mod(Hidx{t} + Algo.H - 2, Algo.H) + 1);
                        MCR{t}(Hidx{t}) = MCR{t}(mod(Hidx{t} + Algo.H - 2, Algo.H) + 1);
                    end
                    Hidx{t} = mod(Hidx{t}, Algo.H) + 1;

                    % Update archive
                    archive{t} = [archive{t}, population{t}(replace)];
                    if length(archive{t}) > N
                        archive{t} = archive{t}(randperm(length(archive{t}), N));
                    end

                    population{t}(replace) = offspring(replace);

                    % Linear Population Size Reduction
                    if length(population{t}) > N
                        CV = population{t}.CVs; CV(CV < Ep) = 0;
                        Obj = population{t}.Objs;
                        [~, rank] = sortrows([CV, Obj], [1, 2]);
                        population{t} = population{t}(rank(1:N));
                    end
                end
            end
        end

        function offspring = Generation(Algo, population, union, Ep)
            % get top 100p% individuals
            CV = population.CVs; CV(CV < Ep) = 0;
            Obj = population.Objs;
            [~, rank] = sortrows([CV, Obj], [1, 2]);
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
