classdef AMT_NSGA_II < Algorithm
% <Multi-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Da2019AMTEA,
%   title    = {Curbing Negative Influences Online for Seamless Transfer Evolutionary Optimization},
%   author   = {Da, Bingshui and Gupta, Abhishek and Ong, Yew-Soon},
%   journal  = {IEEE Transactions on Cybernetics},
%   year     = {2019},
%   number   = {12},
%   pages    = {4365-4378},
%   volume   = {49},
%   doi      = {10.1109/TCYB.2018.2864345},
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
    Delta = 10
    MuC = 20
    MuM = 15
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Delta: Transfer Interval', num2str(Algo.Delta), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.Delta = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization(Algo, Prob, Individual);
        for t = 1:Prob.T
            rank = NSGA2Sort(population{t});
            population{t} = population{t}(rank);
        end
        Flag = false;

        while Algo.notTerminated(Prob, population)
            if Algo.FE < Prob.maxFE / 2
                % Training
                for t = 1:Prob.T
                    % Generation
                    mating_pool = TournamentSelection(2, Prob.N, 1:Prob.N);
                    offspring = Algo.Generation(population{t}(mating_pool));
                    % Evaluation
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    % Selection
                    population{t} = [population{t}, offspring];
                    rank = NSGA2Sort(population{t});
                    population{t} = population{t}(rank(1:Prob.N));
                end
            else
                % Running
                if ~Flag
                    % Setting Before Running
                    for t = 1:Prob.T
                        model{t} = ProbabilityModel('mvarnorm');
                        model{t} = ProbabilityModel.buildmodel(model{t}, population{t}.Decs);
                    end
                    % Re-Initialization
                    population = Initialization(Algo, Prob, Individual);
                    for t = 1:Prob.T
                        rank = NSGA2Sort(population{t});
                        population{t} = population{t}(rank);
                    end
                    Flag = true;
                end
                for t = 1:Prob.T
                    if mod(Algo.Gen, Algo.Delta) == 0
                        % Transfer
                        mmodel = MixtureModel(model);
                        mmodel = MixtureModel.createtable(mmodel, population{t}.Decs, true, 'mvarnorm');
                        mmodel = MixtureModel.EMstacking(mmodel);
                        mmodel = MixtureModel.mutate(mmodel);
                        offspring_Dec = MixtureModel.sample(mmodel, Prob.N);
                        offspring_Dec(offspring_Dec > 1) = 1;
                        offspring_Dec(offspring_Dec < 0) = 0;
                        for i = 1:Prob.N
                            offspring(i) = population{t}(i);
                            offspring(i).Dec = offspring_Dec(i, :);
                        end
                    else
                        % Generation
                        mating_pool = TournamentSelection(2, Prob.N, 1:Prob.N);
                        offspring = Algo.Generation(population{t}(mating_pool));
                    end
                    % Evaluation
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    % Selection
                    population{t} = [population{t}, offspring];
                    rank = NSGA2Sort(population{t});
                    population{t} = population{t}(rank(1:Prob.N));
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
