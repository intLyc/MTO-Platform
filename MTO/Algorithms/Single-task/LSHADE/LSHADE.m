classdef LSHADE < Algorithm
    % <ST-SO> <None>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Tanabe2014LSHADE,
    %   title     = {Improving the Search Performance of Shade Using Linear Population Size Reduction},
    %   author    = {Tanabe, Ryoji and Fukunaga, Alex S.},
    %   booktitle = {2014 IEEE Congress on Evolutionary Computation (CEC)},
    %   year      = {2014},
    %   pages     = {1658-1665},
    %   doi       = {10.1109/CEC.2014.6900380},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        P = 0.1
        H = 100
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'P: 100p% top as pbest', num2str(obj.P), ...
                        'H: success memory size', num2str(obj.H)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.P = str2double(Parameter{i}); i = i + 1;
            obj.H = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual_DE);
            Nmin = 4;
            for t = 1:Prob.T
                % initialize Parameter
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

                    % Generation
                    union = [population{t}, archive{t}];
                    offspring = obj.Generation(population{t}, union);
                    % Evaluation
                    offspring = obj.Evaluation(offspring, Prob, t);
                    % Selection
                    replace = [population{t}.Obj] > [offspring.Obj];

                    % Calculate SF SCR
                    SF = [population{t}(replace).F];
                    SCR = [population{t}(replace).CR];
                    dif = abs([population{t}(replace).Obj] - [offspring(replace).Obj]);
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
                    [~, rank] = sort([population{t}.Obj]);
                    population{t} = population{t}(rank(1:N));
                end
            end
        end

        function offspring = Generation(obj, population, union)
            % get top 100p% individuals
            [~, rank] = sort([population.Obj]);
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
