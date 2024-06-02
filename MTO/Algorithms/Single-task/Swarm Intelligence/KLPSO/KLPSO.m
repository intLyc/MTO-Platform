classdef KLPSO < Algorithm
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
    maxW = 0.9
    minW = 0.4
    C1 = 0.2
    C2 = 0.2
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'LR: Learning Rate', num2str(Algo.LR), ...
                'EP: Epochs', num2str(Algo.EP), ...
                'maxW', num2str(Algo.maxW), ...
                'minW', num2str(Algo.minW), ...
                'C1', num2str(Algo.C1), ...
                'C2', num2str(Algo.C2)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.LR = str2double(Parameter{i}); i = i + 1;
        Algo.EP = str2double(Parameter{i}); i = i + 1;
        Algo.maxW = str2double(Parameter{i}); i = i + 1;
        Algo.minW = str2double(Parameter{i}); i = i + 1;
        Algo.C1 = str2double(Parameter{i}); i = i + 1;
        Algo.C2 = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual_PSO);
        for t = 1:Prob.T
            in_list{t} = [];
            out_list{t} = [];
            trained{t} = 0;
            net{t} = [];
        end

        % Initialize PSO parameter
        for t = 1:Prob.T
            for i = 1:length(population{t})
                population{t}(i).PBestDec = population{t}(i).Dec;
                population{t}(i).PBestObj = population{t}(i).Obj;
                population{t}(i).PBestCV = population{t}(i).CV;
                population{t}(i).V = 0;
            end
        end

        while Algo.notTerminated(Prob, population)
            W = Algo.maxW - (Algo.maxW - Algo.minW) * Algo.FE / Prob.maxFE;

            for t = 1:Prob.T
                old_population = population{t};
                % Generation
                population{t} = Algo.Generation(population{t}, W, Algo.Best{t}, ...
                    net{t}, trained{t});
                % Evaluation
                population{t} = Algo.Evaluation(population{t}, Prob, t);
                % PBest update
                for i = 1:length(population{t})
                    if population{t}(i).CV < population{t}(i).PBestCV || ...
                            (population{t}(i).CV == population{t}(i).PBestCV && ...
                            population{t}(i).Obj < population{t}(i).PBestObj)
                        population{t}(i).PBestDec = population{t}(i).Dec;
                        population{t}(i).PBestObj = population{t}(i).Obj;
                        population{t}(i).PBestCV = population{t}(i).CV;
                    end
                end

                [~, replace] = Selection_Tournament(old_population, population{t});
                OldDec = old_population(replace).Decs;
                NewDec = population{t}(replace).Decs;
                in_list{t} = [in_list{t}; OldDec];
                out_list{t} = [out_list{t}; NewDec - OldDec];

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

    function population = Generation(Algo, population, W, GBest, net, trained)
        for i = 1:length(population)
            if (rand() < Algo.LR && trained == 1)
                testInput = population(i).Dec';
                Y = sim(net, testInput)';
                population(i).Dec = population(i).Dec + 2 * rand() * Y;
            else
                % Velocity update
                population(i).V = W * population(i).V + ...
                    Algo.C1 .* rand() .* (population(i).PBestDec - population(i).Dec) + ...
                    Algo.C2 .* rand() .* (GBest.Dec - population(i).Dec);
                % Position update
                population(i).Dec = population(i).Dec + population(i).V;
            end
            population(i).Dec = max(min(population(i).Dec, 1), 0);
        end
    end
end
end
