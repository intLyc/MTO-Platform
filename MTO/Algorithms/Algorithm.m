classdef Algorithm < handle
    %% Algorithm Base Class
    % Inherit the Algorithm class and implement the abstract functions

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------s

    properties
        Name % Algorithm's Name
        FE % Function evaluations
        Gen % Generations
        FE_Gen % FE in each generations
        Best % Best individual found
        Result % Result of run

        Save_Dec = false % Save Dec Falg
        Result_Num = 100 % Convergence Results Num
        Result_Idx % Result Save Idx
    end

    methods
        function obj = Algorithm(varargin)
            % Algorithm constructor, cannot be changed
            if length(varargin) >= 1
                obj.Name = varargin{1};
            end
            obj.Result_Idx = 1;
            obj.FE = 0;
            obj.Gen = 1;
            obj.FE_Gen = [];
            obj.Best = {};
            obj.Result = {};
        end

        function reset(obj)
            obj.Result_Idx = 1;
            obj.FE = 0;
            obj.Gen = 1;
            obj.FE_Gen = [];
            obj.Best = {};
            obj.Result = {};
        end

        function Parameter = getParameter(obj)
            % Get algorithm's parameter
            % return parameter, contains {para1, value1, para2, value2, ...} (string)
            Parameter = {};
        end

        function setParameter(obj, Parameter)
            % set algorithm's parameter
            % arg parameter_cell, contains {value1, value2, ...} (string)
        end

        function Result = getResult(obj, Prob)
            Result = gen2eva(obj.Result, obj.FE_Gen, obj.Result_Num);
            for t = 1:size(Result, 1)
                for idx = 1:size(Result, 2)
                    if obj.Save_Dec
                        Result{t, idx}.Dec = Prob.Lb{t} + Result{t, idx}.Dec(1:Prob.D(t)) .* (Prob.Ub{t} - Prob.Lb{t});
                    else
                        Result{t, idx} = rmfield(Result{t, idx}, 'Dec');
                    end
                end
            end
        end

        function flag = notTerminated(obj, Prob)
            if isempty(obj.Best)
                flag = true;
                return;
            end

            flag = obj.FE < Prob.maxFE;

            for t = 1:Prob.T
                Struct = [];
                Struct(1).Obj = obj.Best{t}.Obj;
                Struct(1).CV = obj.Best{t}.CV;
                Struct(1).Dec = obj.Best{t}.Dec;
                obj.Result{t, obj.Gen} = Struct;
            end
            obj.FE_Gen(obj.Gen) = obj.FE;
            obj.Gen = obj.Gen + 1;
        end

        function [Pop, Flag] = Evaluation(obj, Pop, Prob, t)
            for i = 1:length(Pop)
                x = (Prob.Ub{t} - Prob.Lb{t}) .* Pop(i).Dec(1:Prob.D(t)) + Prob.Lb{t};
                [Obj, Con] = Prob.Fnc{t}(x);
                CV = sum(Con);
                Pop(i).Obj = Obj;
                Pop(i).CV = CV;
            end
            obj.FE = obj.FE + length(Pop);

            % Update Best
            if isempty(obj.Best)
                for k = 1:Prob.T
                    obj.Best{k} = Individual.empty();
                end
            end
            [~, ~, idx] = min_FP([Pop.Obj], [Pop.CV]);
            BestTemp = Individual();
            BestTemp.Dec = Pop(idx).Dec;
            BestTemp.Obj = Pop(idx).Obj;
            BestTemp.CV = Pop(idx).CV;
            BestTemp = [BestTemp, obj.Best{t}];
            [~, ~, idx] = min_FP([BestTemp.Obj], [BestTemp.CV]);
            obj.Best{t} = BestTemp(idx);
            % Set Best Update Flag
            if idx == 1
                Flag = true;
            else
                Flag = false;
            end
        end
    end

    methods (Abstract)
        run(obj, Prob) % run this tasks with algorithm,
    end
end
