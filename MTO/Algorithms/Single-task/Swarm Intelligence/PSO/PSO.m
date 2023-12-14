classdef PSO < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Kennedy1995PSO,
%   author     = {Kennedy, J. and Eberhart, R.},
%   booktitle  = {Proceedings of ICNN'95 - International Conference on Neural Networks},
%   title      = {Particle Swarm Optimization},
%   year       = {1995},
%   pages      = {1942-1948 vol.4},
%   volume     = {4},
%   doi        = {10.1109/ICNN.1995.488968},
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
    maxW = 0.9
    minW = 0.4
    C1 = 0.2
    C2 = 0.2
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'maxW', num2str(Algo.maxW), ...
                'minW', num2str(Algo.minW), ...
                'C1', num2str(Algo.C1), ...
                'C2', num2str(Algo.C2)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.maxW = str2double(Parameter{i}); i = i + 1;
        Algo.minW = str2double(Parameter{i}); i = i + 1;
        Algo.C1 = str2double(Parameter{i}); i = i + 1;
        Algo.C2 = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual_PSO);

        % Initialize PSO parameter
        for t = 1:Prob.T
            for i = 1:length(population{t})
                population{t}(i).PBestDec = population{t}(i).Dec;
                population{t}(i).PBestObj = population{t}(i).Obj;
                population{t}(i).PBestCV = population{t}(i).CV;
                population{t}(i).V = 0;
            end
        end

        while Algo.notTerminated(Prob)
            W = Algo.maxW - (Algo.maxW - Algo.minW) * Algo.FE / Prob.maxFE;

            for t = 1:Prob.T
                % Generation
                population{t} = Algo.Generation(population{t}, W, Algo.Best{t});
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
            end
        end
    end

    function population = Generation(Algo, population, W, GBest)
        for i = 1:length(population)
            % Velocity update
            population(i).V = W * population(i).V + ...
            Algo.C1 .* rand() .* (population(i).PBestDec - population(i).Dec) + ...
                Algo.C2 .* rand() .* (GBest.Dec - population(i).Dec);

            % Position update
            population(i).Dec = population(i).Dec + population(i).V;

            population(i).Dec(population(i).Dec > 1) = 1;
            population(i).Dec(population(i).Dec < 0) = 0;
        end
    end
end
end
