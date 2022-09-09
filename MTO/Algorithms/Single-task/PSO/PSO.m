classdef PSO < Algorithm
    % <ST-SO> <None/Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        maxW = 0.9
        minW = 0.4
        C1 = 0.2
        C2 = 0.2
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'maxW', num2str(obj.maxW), ...
                        'minW', num2str(obj.minW), ...
                        'C1', num2str(obj.C1), ...
                        'C2', num2str(obj.C2)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.maxW = str2double(Parameter{i}); i = i + 1;
            obj.minW = str2double(Parameter{i}); i = i + 1;
            obj.C1 = str2double(Parameter{i}); i = i + 1;
            obj.C2 = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual_PSO);

            % Initialize PSO parameter
            for t = 1:Prob.T
                for i = 1:length(population{t})
                    population{t}(i).PBestDec = population{t}(i).Dec;
                    population{t}(i).PBestObj = population{t}(i).Obj;
                    population{t}(i).PBestCV = population{t}(i).CV;
                    population{t}(i).V = 0;
                end
            end

            while obj.notTerminated(Prob)
                W = obj.maxW - (obj.maxW - obj.minW) * obj.FE / Prob.maxFE;

                for t = 1:Prob.T
                    % Generation
                    population{t} = obj.Generation(population{t}, W, obj.Best{t});
                    % Evaluation
                    population{t} = obj.Evaluation(population{t}, Prob, t);
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

        function population = Generation(obj, population, W, GBest)
            for i = 1:length(population)
                % Velocity update
                population(i).V = W * population(i).V + ...
                obj.C1 .* rand() .* (population(i).PBestDec - population(i).Dec) + ...
                    obj.C2 .* rand() .* (GBest.Dec - population(i).Dec);

                % Position update
                population(i).Dec = population(i).Dec + population(i).V;

                population(i).Dec(population(i).Dec > 1) = 1;
                population(i).Dec(population(i).Dec < 0) = 0;
            end
        end
    end
end
