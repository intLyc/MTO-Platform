classdef rank_jDE < Algorithm
    % <Single> <None>

    %------------------------------- Reference --------------------------------
    % @Article{Gong2013rank-DE,
    %   author     = {Gong, Wenyin and Cai, Zhihua},
    %   journal    = {IEEE Transactions on Cybernetics},
    %   title      = {Differential Evolution With Ranking-Based Mutation Operators},
    %   year       = {2013},
    %   number     = {6},
    %   pages      = {2066-2081},
    %   volume     = {43},
    %   doi        = {10.1109/TCYB.2013.2239988},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        t1 = 0.1;
        t2 = 0.1;
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'t1: probability of F change', num2str(obj.t1), ...
                        't2: probability of CR change', num2str(obj.t2)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.t1 = str2double(Parameter{i}); i = i + 1;
            obj.t2 = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            convergeObj = {}; bestDec = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls, bestDec_temp, bestObj] = initialize(IndividualRank, sub_pop, Task, Task.Dim);
                convergeObj_temp(1) = bestObj;

                % initialize F and CR
                for i = 1:length(population)
                    population(i).F = rand * 0.9 + 0.1;
                    population(i).CR = rand;
                end

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % generation
                    [offspring, calls] = OperatorjDE_rank.generate(population, Task, obj.t1, obj.t2);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace = [population.Obj] > [offspring.Obj];
                    population(replace) = offspring(replace);
                    [bestObj_now, idx] = min([population.Obj]);
                    if bestObj_now < bestObj
                        bestObj = bestObj_now;
                        bestDec_temp = population(idx).Dec;
                    end
                    convergeObj_temp(generation) = bestObj;
                end
                convergeObj{sub_task} = convergeObj_temp;
                bestDec{sub_task} = bestDec_temp;
            end
            data.convergeObj = gen2eva(cell2matrix(convergeObj));
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
