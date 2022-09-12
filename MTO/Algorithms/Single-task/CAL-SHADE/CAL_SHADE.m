classdef CAL_SHADE < Algorithm
    % <ST-SO> <Constrained>

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
        TopEC = 0.2
        TcEC = 0.8
        CpEC = 5
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'P: 100p% top as pbest', num2str(obj.P), ...
                        'H: success memory size', num2str(obj.H), ...
                        'TopEC', num2str(obj.TopEC), ...
                        'TcEC', num2str(obj.TcEC), ...
                        'CpEC', num2str(obj.CpEC)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.P = str2double(Parameter{i}); i = i + 1;
            obj.H = str2double(Parameter{i}); i = i + 1;
            obj.TopEC = str2double(Parameter{i}); i = i + 1;
            obj.TcEC = str2double(Parameter{i}); i = i + 1;
            obj.CpEC = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual_DE);
            Nmin = 4;
            for t = 1:Prob.T
                % initialize Parameter
                n = ceil(obj.TopEC * length(population{t}));
                cv_temp = [population{t}.CV];
                [~, idx] = sort(cv_temp);
                Ep0{t} = cv_temp(idx(n));
                Hidx{t} = 1;
                MF{t} = 0.5 .* ones(obj.H, 1);
                MCR{t} = 0.5 .* ones(obj.H, 1);
                archive{t} = Individual_DE.empty();
            end

            while obj.notTerminated(Prob)
                N = round((Nmin - Prob.N) / Prob.maxFE * obj.FE + Prob.N);
                for t = 1:Prob.T
                    % Calculate individual F and CR
                    for i = 1:length(population{t})
                        idx = randi(obj.H);
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
                    if obj.FE < obj.TcEC * Prob.maxFE
                        Ep = Ep0{t} * ((1 - obj.FE / (obj.TcEC * Prob.maxFE))^obj.CpEC);
                    else
                        Ep = 0;
                    end

                    % Generation
                    union = [population{t}, archive{t}];
                    offspring = obj.Generation(population{t}, union, Ep);
                    % Evaluation
                    offspring = obj.Evaluation(offspring, Prob, t);
                    % Selection
                    [~, replace] = Selection_Tournament(population{t}, offspring, Ep);

                    % calculate SF SCR
                    SF = [population{t}(replace).F];
                    SCR = [population{t}(replace).CR];
                    dif = [population{t}(replace).CV] - [offspring(replace).CV];
                    dif_obj = [population{t}(replace).Obj] - [offspring(replace).Obj];
                    dif_obj(dif_obj < 0) = 0;
                    dif(dif <= 0) = dif_obj(dif <= 0);
                    dif = dif ./ sum(dif);
                    % update MF MCR
                    if ~isempty(SF)
                        MF{t}(Hidx{t}) = sum(dif .* (SF.^2)) / sum(dif .* SF);
                        MCR{t}(Hidx{t}) = sum(dif .* SCR);
                    else
                        MF{t}(Hidx{t}) = MF{t}(mod(Hidx{t} + obj.H - 2, obj.H) + 1);
                        MCR{t}(Hidx{t}) = MCR{t}(mod(Hidx{t} + obj.H - 2, obj.H) + 1);
                    end
                    Hidx{t} = mod(Hidx{t}, obj.H) + 1;

                    % Update archive
                    archive{t} = [archive{t}, population{t}(replace)];
                    if length(archive{t}) > N
                        archive{t} = archive{t}(randperm(length(archive{t}), N));
                    end

                    population{t}(replace) = offspring(replace);

                    % Linear Population Size Reduction
                    if length(population{t}) > N
                        CV = [population{t}.CV]; CV(CV < Ep) = 0;
                        Obj = [population{t}.Obj];
                        [~, rank] = sortrows([CV', Obj'], [1, 2]);
                        population{t} = population{t}(rank(1:N));
                    end
                end
            end
        end

        function offspring = Generation(obj, population, union, Ep)
            % get top 100p% individuals
            CV = [population.CV]; CV(CV < Ep) = 0;
            Obj = [population.Obj];
            [~, rank] = sortrows([CV', Obj'], [1, 2]);
            pop_pbest = rank(1:max(round(obj.P * length(population)), 1));

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
