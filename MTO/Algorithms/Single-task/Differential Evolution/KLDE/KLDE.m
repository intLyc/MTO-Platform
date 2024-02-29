classdef KLDE < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Jiang2023KLEC,
%   title      = {Knowledge Learning for Evolutionary Computation},
%   author     = {Jiang, Yi and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
%   journal   = {IEEE Transactions on Evolutionary Computation},
%   year       = {2023},
%   pages      = {1-1},
%   doi        = {10.1109/TEVC.2023.3278132},
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
    LR = 0.2
    EP = 10
    F = 0.5
    CR = 0.9
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'LR: Learning Rate', num2str(Algo.LR), ...
                'EP: Epochs', num2str(Algo.EP), ...
                'F: Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Rate', num2str(Algo.CR)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.LR = str2double(Parameter{i}); i = i + 1;
        Algo.EP = str2double(Parameter{i}); i = i + 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual);
        for t = 1:Prob.T
            in_list{t} = [];
            out_list{t} = [];
            trained{t} = 0;
            net{t} = [];
        end

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                % Generation
                offspring = Algo.Generation(population{t}, net{t}, trained{t});
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                [~, replace] = Selection_Tournament(population{t}, offspring);
                OldDec = population{t}(replace).Decs;
                NewDec = offspring(replace).Decs;
                in_list{t} = [in_list{t}; OldDec];
                out_list{t} = [out_list{t}; NewDec - OldDec];
                population{t}(replace) = offspring(replace);

                % Train Model
                if (trained{t} == 0)
                    net{t} = newff(minmax(in_list{t}'), [16 16 max(Prob.D)], {'logsig' 'logsig' 'purelin'}, 'traingdx');
                    net{t}.trainparam.show = 10;
                    net{t}.trainparam.epochs = Algo.EP;
                    net{t}.trainParam.lr = 0.1;
                    net{t}.trainParam.showWindow = false;
                    net{t}.trainParam.showCommandLine = false;
                    trained{t} = 1;
                end

                if (size(in_list{t}, 1) > 0)
                    net{t} = train(net{t}, in_list{t}', out_list{t}');
                end

                in_list{t} = [];
                out_list{t} = [];
            end
        end
    end

    function offspring = Generation(Algo, population, net, trained)
        for i = 1:length(population)
            offspring(i) = population(i);
            A = randperm(length(population), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

            if (rand() < Algo.LR && trained == 1)
                testInput = population(x1).Dec';
                Y = sim(net, testInput)';
                offspring(i).Dec = population(x1).Dec + 2 * rand() * Y;
            else
                offspring(i).Dec = population(x1).Dec + Algo.F * (population(x2).Dec - population(x3).Dec);
            end
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.CR);
            population(i).Dec = max(min(population(i).Dec, 1), 0);
        end
    end
end
end
