classdef MO_EMEA < Algorithm
% <Multi-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Feng2019EMEA,
%   title      = {Evolutionary Multitasking via Explicit Autoencoding},
%   author     = {Feng, Liang and Zhou, Lei and Zhong, Jinghui and Gupta, Abhishek and Ong, Yew-Soon and Tan, Kay-Chen and Qin, A. K.},
%   journal    = {IEEE Transactions on Cybernetics},
%   year       = {2019},
%   number     = {9},
%   pages      = {3457-3470},
%   volume     = {49},
%   doi        = {10.1109/TCYB.2018.2845361},
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
    Operator = 'SP/NS'
    SNum = 10
    TGap = 10
    MuC = 20
    MuM = 15
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Operator (Split with /)', Algo.Operator, ...
                'S: Transfer num', num2str(Algo.SNum), ...
                'G: Transfer TGap', num2str(Algo.TGap), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function setParameter(Algo, Parameter)
        i = 1; Algo.Operator = Parameter{i}; i = i + 1;
        Algo.SNum = str2double(Parameter{i}); i = i + 1;
        Algo.TGap = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i});
    end

    function run(Algo, Prob)
        operator = split(Algo.Operator, '/');

        % Initialize
        population = Initialization(Algo, Prob, Individual);
        for t = 1:Prob.T
            [population{t}, Fitness{t}] = Selection_SPEA2(population{t}, Prob.N);
        end

        init_pop_dec = {};
        for t = 1:Prob.T
            init_pop_dec{t} = population{t}.Decs;
            init_pop_dec{t} = init_pop_dec{t}(:, 1:Prob.D(t));
            init_pop_dec{t} = (Prob.Ub{t} - Prob.Lb{t}) .* init_pop_dec{t} + Prob.Lb{t};
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                % Generation
                mating_pool = TournamentSelection(2, Prob.N, Fitness{t});
                offspring = Algo.Generation(population{t}(mating_pool));

                % Knowledge Transfer
                if Algo.SNum > 0 && mod(Algo.Gen, Algo.TGap) == 0
                    inject_num = round(Algo.SNum ./ (Prob.T - 1));
                    inject_pop = Individual.empty();
                    for k = 1:Prob.T
                        if t == k
                            continue;
                        end

                        % extract best dec
                        his_pop_dec = population{k}.Decs;
                        his_best_dec = his_pop_dec(1:inject_num, 1:Prob.D(k));

                        % map to original
                        his_best_dec = (Prob.Ub{k} - Prob.Lb{k}) .* his_best_dec + Prob.Lb{k};

                        % autoencoding transfer
                        inject = mDA(init_pop_dec{t}, init_pop_dec{k}, his_best_dec);

                        % mat to [0,1]
                        inject = (inject - Prob.Lb{t}) ./ (Prob.Ub{t} - Prob.Lb{t});

                        for i = 1:size(inject, 1)
                            c = Individual();
                            c.Dec = [inject(i, :), rand(1, max(Prob.D) - Prob.D(t))];
                            c.Dec(c.Dec > 1) = 1;
                            c.Dec(c.Dec < 0) = 0;
                            inject_pop = [inject_pop, c];
                        end
                    end
                    replace_idx = randperm(length(offspring), length(inject_pop));
                    offspring(replace_idx) = inject_pop;
                end

                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                population{t} = [population{t}, offspring];
                op_idx = mod(t - 1, length(operator)) + 1;
                op = operator{op_idx};
                switch op
                    case 'SP' % SPEA2
                        [population{t}, Fitness{t}] = Selection_SPEA2(population{t}, Prob.N);
                    case 'NS' % NSGA-II
                        rank = NSGA2Sort(population{t});
                        population{t} = population{t}(rank(1:Prob.N));
                        Fitness{t} = 1:Prob.N;
                end
            end
        end
    end

    function offspring = Generation(Algo, population)
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = i; p2 = i + fix(length(population) / 2);
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);

            [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);

            offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
            offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.MuM);

            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end
end
end
