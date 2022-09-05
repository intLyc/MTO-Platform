classdef TLTLA < Algorithm
    % <Multi> <None>

    %------------------------------- Reference --------------------------------
    % @Article{Ma2020TLTLA,
    %   author    = {Ma, Xiaoliang and Chen, Qunjian and Yu, Yanan and Sun, Yiwen and Ma, Lijia and Zhu, Zexuan},
    %   journal   = {Frontiers in neuroscience},
    %   title     = {A Two-level Transfer Learning Algorithm for Evolutionary Multitasking},
    %   year      = {2020},
    %   pages     = {1408},
    %   volume    = {13},
    %   publisher = {Frontiers},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        rmp = 0.3
        mu = 2;
        mum = 5;
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.rmp = str2double(Parameter{i}); i = i + 1;
            obj.mu = str2double(Parameter{i}); i = i + 1;
            obj.mum = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);

            % initialize
            [population, fnceval_calls, bestDec, bestObj] = initializeMF(IndividualMF, pop_size, Tasks, max([Tasks.Dim]));
            convergeObj(:, 1) = bestObj;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % Upper-level: Inter-task Knowledge Transfer
                % generation
                [offspring, calls] = OperatorTLTLA.generate(population, Tasks, obj.rmp, obj.mu, obj.mum);
                fnceval_calls = fnceval_calls + calls;
                % selection
                [population, bestDec, bestObj] = selectMF(population, offspring, Tasks, pop_size, bestDec, bestObj);

                % Lower-level: Intra-task Knowledge Transfer
                parent = randi(length(population));
                t = population(parent).skill_factor;
                dimen = mod(generation - 2, max([Tasks.Dim])) + 1; % start with 1 Dim
                child_Dec = zeros(size(population(parent)));
                pool = population([population.skill_factor] == t);
                for d = 1:max([Tasks.Dim])
                    x = randperm(length(pool), min(3, length(pool)));
                    if length(pool) < 3
                        child_Dec(d) = pool(x(1)).Dec(dimen);
                        continue;
                    end
                    if rand > 0.5
                        child_Dec(d) = pool(x(1)).Dec(dimen) + 0.5 * rand * (pool(x(2)).Dec(dimen) - pool(x(3)).Dec(dimen));
                    else
                        child_Dec(d) = pool(x(1)).Dec(dimen) + 0.5 * rand * (pool(x(3)).Dec(dimen) - pool(x(2)).Dec(dimen));
                    end
                end
                child_Dec(child_Dec > 1) = 1;
                child_Dec(child_Dec < 0) = 0;

                if rand > 0.5
                    tmp_population = population(parent);
                    for d = 1:max([Tasks.Dim])
                        tmp_population.Dec(d) = child_Dec(d);
                        [tmp_population, calls] = evaluate(tmp_population, Tasks(t), t);
                        fnceval_calls = fnceval_calls + calls;

                        if tmp_population.Obj(t) < population(parent).Obj(t)
                            population(parent) = tmp_population;
                            break;
                        end
                    end
                else
                    for d = 1:max([Tasks.Dim])
                        tmp_population = population(parent);
                        tmp_population.Dec(d) = child_Dec(d);
                        [tmp_population, calls] = evaluate(tmp_population, Tasks(t), t);
                        fnceval_calls = fnceval_calls + calls;

                        if tmp_population.Obj(t) < population(parent).Obj(t)
                            population(parent) = tmp_population;
                            break;
                        end
                    end
                end

                if population(parent).Obj(t) < bestObj(t)
                    bestObj(t) = population(parent).Obj(t);
                    bestDec{t} = population(parent).Dec;
                end

                convergeObj(:, generation) = bestObj;
            end
            data.convergeObj = gen2eva(convergeObj);
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
