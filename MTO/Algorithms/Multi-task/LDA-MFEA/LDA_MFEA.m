classdef LDA_MFEA < Algorithm
    % <MT-SO> <None>

    %------------------------------- Reference --------------------------------
    % @inproceedings{Bali2017LDA-MFEA,
    %   title     = {Linearized Domain Adaptation in Evolutionary Multitasking},
    %   author    = {Bali, Kavitesh Kumar and Gupta, Abhishek and Feng, Liang and Ong, Yew Soon and Tan Puay Siew},
    %   booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
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
        RMP = 0.3
        MuC = 2
        MuM = 5
        H = 10
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'RMP: Random Mating Probability', num2str(obj.RMP), ...
                        'MuC: Simulated Binary Crossover', num2str(obj.MuC), ...
                        'MuM: Polynomial Mutation', num2str(obj.MuM), ...
                        'H: Store Max Length', num2str(obj.H)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.RMP = str2double(Parameter{i}); i = i + 1;
            obj.MuC = str2double(Parameter{i}); i = i + 1;
            obj.MuM = str2double(Parameter{i}); i = i + 1;
            obj.H = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialize
            population = Initialization_MF(obj, Prob, Individual_MF);
            for t = 1:Prob.T
                P{t} = []; M{t} = [];
            end

            while obj.notTerminated(Prob)
                % Extract Task specific Data Sets
                for t = 1:Prob.T
                    subpops(t).data = []; f(t).cost = [];
                end
                for i = 1:length(population)
                    subpops(population(i).MFFactor).data = [subpops(population(i).MFFactor).data; population(i).Dec];
                    f(population(i).MFFactor).cost = [f(population(i).MFFactor).cost; population(i).MFObj(population(i).MFFactor)];
                end

                for t = 1:Prob.T
                    if size(P{t}, 1) > obj.H * Prob.N
                        P{t} = P{t}(end - obj.H * Prob.N:end, :);
                    end
                    % Accumulate all historical points of t and sort according to objective
                    temp = [P{t}; [subpops(t).data, f(t).cost]];
                    temp = sortrows(temp, max(Prob.D) + 1);
                    P{t} = temp;
                    M{t} = temp(:, 1:end - 1); % extract chromosomes except the last column(Obj), store into matrix
                end

                % Generation
                offspring = obj.Generation(population, M, Prob.D);
                % Evaluation
                offspring_temp = Individual_MF.empty();
                for t = 1:Prob.T
                    offspring_t = offspring([offspring.MFFactor] == t);
                    offspring_t = obj.Evaluation(offspring_t, Prob, t);
                    for i = 1:length(offspring_t)
                        offspring_t(i).MFObj = inf(1, Prob.T);
                        offspring_t(i).MFCV = inf(1, Prob.T);
                        offspring_t(i).MFObj(t) = offspring_t(i).Obj;
                        offspring_t(i).MFCV(t) = offspring_t(i).CV;
                    end
                    offspring_temp = [offspring_temp, offspring_t];
                end
                offspring = offspring_temp;
                % Selection
                population = Selection_MF(population, offspring, Prob);
            end
        end

        function offspring = Generation(obj, population, M, Dim)
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = population(p1);
                offspring(count + 1) = population(p2);
                temp_offspring = offspring(count);

                if (population(p1).MFFactor == population(p2).MFFactor) || rand() < obj.RMP
                    % crossover
                    [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, obj.MuC);
                    % imitation
                    p = [p1, p2];
                    offspring(count).MFFactor = population(p(randi(2))).MFFactor;
                    offspring(count + 1).MFFactor = population(p(randi(2))).MFFactor;
                else % LDA
                    t1 = population(p1).MFFactor; t2 = population(p2).MFFactor;

                    diff = abs(size(M{t1}, 1) - size(M{t2}, 1));
                    % same number of rows for both task populations.
                    % for matrix mapping
                    if size(M{t1}, 1) < size(M{t2}, 1)
                        M{t2} = M{t2}(1:end - diff, :);
                    else
                        M{t1} = M{t1}(1:end - diff, :);
                    end

                    % find Linear Least square mapping between two tasks.
                    if (Dim(t1) > Dim(t2)) % swap t1, t2, make t1.Dim < t2.Dim
                        tt = t1; t1 = t2; t2 = tt;
                        pp = p1; p1 = p2; p2 = pp;
                    end

                    % map t1 to t2 (low to high dim)
                    [m1, m2] = obj.mapping(M{t1}, M{t2});
                    temp_offspring.Dec = population(p1).Dec * m1;
                    % crossover
                    [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(temp_offspring.Dec, population(p2).Dec, obj.MuC);
                    % mutation
                    offspring(count).Dec = GA_Mutation(population(p1).Dec, obj.MuM);
                    offspring(count + 1).Dec = GA_Mutation(population(p2).Dec, obj.MuM);
                    % imitation
                    p = [p1, p2];
                    rand_p = p(randi(2));
                    offspring(count).MFFactor = population(rand_p).MFFactor;
                    if offspring(count).MFFactor == t1
                        offspring(count).Dec = offspring(count).Dec * m2;
                    end
                    rand_p = p(randi(2));
                    offspring(count + 1).MFFactor = population(rand_p).MFFactor;
                    if offspring(count + 1).MFFactor == t1
                        offspring(count + 1).Dec = offspring(count + 1).Dec * m2;
                    end
                end
                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end
        end

        function [m1, m2] = mapping(obj, a, b)
            m1 = (inv(transpose(a) * a)) * (transpose(a) * b);
            m2 = transpose(m1) * (inv(m1 * transpose(m1)));
        end
    end
end
