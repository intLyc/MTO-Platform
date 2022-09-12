classdef MFMP < Algorithm
    % <MT-SO> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Li2020MFMP,
    %   title      = {Multifactorial Optimization Via Explicit Multipopulation Evolutionary Framework},
    %   author     = {Genghui Li and Qiuzhen Lin and Weifeng Gao},
    %   journal    = {Information Sciences},
    %   year       = {2020},
    %   issn       = {0020-0255},
    %   pages      = {1555-1570},
    %   volume     = {512},
    %   doi        = {https://doi.org/10.1016/j.ins.2019.10.066},
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
        H = 100
        Theta = 0.2
        C = 0.3
        Alpha = 0.25
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'P: 100p% top as pbest', num2str(obj.P), ...
                        'H: success memory size', num2str(obj.H), ...
                        'Theta', num2str(obj.Theta), ...
                        'C', num2str(obj.C), ...
                        'Alpha', num2str(obj.Alpha)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.P = str2double(Parameter{i}); i = i + 1;
            obj.H = str2double(Parameter{i}); i = i + 1;
            obj.Theta = str2double(Parameter{i}); i = i + 1;
            obj.C = str2double(Parameter{i}); i = i + 1;
            obj.Alpha = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual_DE);
            reduce_flag = false;
            SR(:, 1) = ones(Prob.T, 1);
            RMP(:, 1) = 0.5 * ones(Prob.T, 1);
            for t = 1:Prob.T
                % initialize Parameter
                Hidx{t} = 1;
                MF{t} = 0.5 .* ones(obj.H, 1);
                MCR{t} = 0.5 .* ones(obj.H, 1);
                archive{t} = Individual_DE.empty();
            end

            while obj.notTerminated(Prob)
                for t = 1:Prob.T
                    % Randomly choose an task to communicate
                    task_idx = 1:Prob.T;
                    task_idx(t) = [];
                    c_idx = task_idx(randi(length(task_idx)));

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
                    c_union = [population{c_idx}, archive{c_idx}];
                    [offspring, flag] = obj.Generation(population{t}, union, population{c_idx}, c_union, RMP(t, obj.Gen - 1));
                    % Evaluation
                    offspring = obj.Evaluation(offspring, Prob, t);
                    % Selection
                    [~, replace] = Selection_Tournament(population{t}, offspring);

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
                    if length(archive{t}) > Prob.N
                        archive{t} = archive{t}(randperm(length(archive{t}), Prob.N));
                    end

                    population{t}(replace) = offspring(replace);

                    % update RMP
                    SR(t, obj.Gen) = sum(replace) / length(population{t});
                    if SR(t, obj.Gen) >= obj.Theta
                        RMP(t, obj.Gen) = RMP(t, obj.Gen - 1);
                    else
                        if sum(flag) == 0
                            RMP(t, obj.Gen) = min(RMP(t, obj.Gen - 1) + obj.C * (1 - SR(t, obj.Gen)), 1);
                        else
                            temp = (sum(replace & flag) / sum(flag));
                            if temp > SR(t, obj.Gen)
                                RMP(t, obj.Gen) = min(RMP(t, obj.Gen - 1) + obj.C * temp, 1);
                            else
                                RMP(t, obj.Gen) = max(RMP(t, obj.Gen - 1) - obj.C * (1 - temp), 0);
                            end
                        end
                    end
                end

                % Population reduction
                if ~reduce_flag && obj.FE >= Prob.maxFE * obj.Alpha
                    N = round(Prob.N / 2);
                    for t = 1:Prob.T
                        [~, rank] = sortrows([[population{t}.CV]', [population{t}.Obj]'], [1, 2]);
                        % save to archive
                        archive{t} = [archive{t}, population{t}(rank(N + 1:end))];
                        if length(archive{t}) > Prob.N
                            archive{t} = archive{t}(randperm(length(archive{t}), Prob.N));
                        end
                        % reduce
                        population{t} = population{t}(rank(1:N));
                    end
                    reduce_flag = true;
                end
            end
        end

        function [offspring, flag] = Generation(obj, population, union, c_pop, c_union, RMP)
            % get top 100p% individuals
            [~, rank] = sortrows([[population.CV]', [population.Obj]'], [1, 2]);
            pop_pbest = rank(1:max(round(obj.P * length(population)), 1));
            [~, rank] = sortrows([[c_pop.CV]', [c_pop.Obj]'], [1, 2]);
            c_pop_pbest = rank(1:max(round(obj.P * length(c_pop)), 1));

            flag = zeros(1, length(population));
            for i = 1:length(population)
                offspring(i) = population(i);

                if rand() < RMP
                    c_pbest = c_pop_pbest(randi(length(c_pop_pbest)));
                    x1 = randi(length(c_pop));
                    while x1 == c_pbest
                        x1 = randi(length(c_pop));
                    end
                    x2 = randi(length(c_union));
                    while x2 == x1 || x2 == c_pbest
                        x2 = randi(length(c_union));
                    end

                    offspring(i).Dec = population(i).Dec + ...
                        population(i).F * (c_pop(c_pbest).Dec - population(i).Dec) + ...
                        population(i).F * (c_pop(x1).Dec - c_union(x2).Dec);
                    offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, population(i).CR);
                    flag(i) = 1;
                else
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
                end

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
