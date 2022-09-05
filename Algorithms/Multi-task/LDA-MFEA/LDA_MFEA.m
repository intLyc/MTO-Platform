classdef LDA_MFEA < Algorithm
    % <Multi> <None>

    %------------------------------- Reference --------------------------------
    % @inproceedings{Bali2017LDA-MFEA,
    %   author    = {Bali, Kavitesh Kumar and Gupta, Abhishek and Feng, Liang and Ong, Yew Soon and Tan Puay Siew},
    %   booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %   title     = {Linearized Domain Adaptation in Evolutionary Multitasking},
    %   year      = {2017},
    %   pages     = {1295-1302},
    %   doi       = {10.1109/CEC.2017.7969454},
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
        store_max = 1000;
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum), ...
                        'store_max: gene store max length', num2str(obj.store_max)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.rmp = str2double(Parameter{i}); i = i + 1;
            obj.mu = str2double(Parameter{i}); i = i + 1;
            obj.mum = str2double(Parameter{i}); i = i + 1;
            obj.store_max = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);

            % initialize
            [population, fnceval_calls, bestDec, bestObj] = initializeMFone(IndividualMF, pop_size, Tasks, max([Tasks.Dim]));
            convergeObj(:, 1) = bestObj;

            % initialize lda
            for t = 1:length(Tasks)
                P{t} = [];
                M{t} = [];
            end

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % Extract Task specific Data Sets
                for t = 1:length(Tasks)
                    subpops(t).data = [];
                    f(t).cost = [];
                end
                for i = 1:length(population)
                    subpops(population(i).skill_factor).data = [subpops(population(i).skill_factor).data; population(i).Dec];
                    f(population(i).skill_factor).cost = [f(population(i).skill_factor).cost; population(i).Obj(population(i).skill_factor)];
                end

                for t = 1:length(Tasks)
                    if size(P{t}, 1) > obj.store_max
                        P{t} = P{t}(end - obj.store_max:end, :);
                    end
                    % accumulate all historical points of t  and sort according to factorial cost
                    temp = [P{t}; [subpops(t).data, f(t).cost]];
                    temp = sortrows(temp, max([Tasks.Dim]) + 1);
                    P{t} = temp;
                    M{t} = temp(:, 1:end - 1); %extract chromosomes except the last column(Obj), store into matrix
                end

                % generation
                [offspring, calls] = OperatorMFEA_LDA.generate(population, Tasks, obj.rmp, obj.mu, obj.mum, M);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestDec, bestObj] = selectMF(population, offspring, Tasks, pop_size, bestDec, bestObj);
                convergeObj(:, generation) = bestObj;
            end
            data.convergeObj = gen2eva(convergeObj);
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
