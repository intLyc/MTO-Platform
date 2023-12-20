classdef Algorithm < handle
%% Algorithm Base Class
% Inherit the Algorithm class and implement the abstract functions

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties
    Name % Algorithm Name
    FE % Function evaluations
    Gen % Generations
    FE_Gen % FE in each Gen
    Best % Best individual found (Single-objective)
    Result % Result after run
    Result_Num % Convergence Results Num
    Save_Dec % Save Decision Variables Flag
end

methods
    function Algo = Algorithm(varargin)
        % Algorithm constructor, cannot be changed
        if length(varargin) >= 1
            Algo.Name = varargin{1};
        end
        Algo.FE = 0;
        Algo.Gen = 1;
        Algo.FE_Gen = [];
        Algo.Best = {};
        Algo.Result = [];
    end

    function reset(Algo)
        Algo.FE = 0;
        Algo.Gen = 1;
        Algo.FE_Gen = [];
        Algo.Best = {};
        Algo.Result = [];
    end

    function Parameter = getParameter(Algo)
        % Get algorithm's parameter
        % return parameter, contains {para1, value1, para2, value2, ...} (string)
        Parameter = {};
    end

    function setParameter(Algo, Parameter)
        % set algorithm's parameter
        % arg parameter_cell, contains {value1, value2, ...} (string)
    end

    function Result = getResult(Algo, Prob)
        Result = gen2eva(Algo.Result, Algo.FE_Gen, Algo.Result_Num);
        if Algo.Save_Dec
            for t = 1:size(Result, 1)
                for idx = 1:size(Result, 2)
                    Result(t, idx).Dec = Prob.Lb{t} + ...
                        Result(t, idx).Dec(:, 1:Prob.D(t)) .* (Prob.Ub{t} - Prob.Lb{t});
                    Result(t, idx).Dec(:, Prob.D(t) + 1:max(Prob.D)) = NaN;
                end
            end
        else
            Result = rmfield(Result, 'Dec');
        end
    end

    function flag = notTerminated(Algo, varargin)
        if length(varargin) == 1
            Prob = varargin{1};
        elseif length(varargin) == 2
            Prob = varargin{1};
            Pop = varargin{2};
        end

        if Algo.FE == 0
            flag = true;
            return;
        end
        flag = Algo.FE < Prob.maxFE;

        for t = 1:Prob.T
            if max(Prob.M) == 1 % Single-objective
                Algo.Result(t, Algo.Gen).Obj = Algo.Best{t}.Obj;
                Algo.Result(t, Algo.Gen).CV = Algo.Best{t}.CV;
                Algo.Result(t, Algo.Gen).Dec = Algo.Best{t}.Dec;
            else % Multi-objective
                Algo.Result(t, Algo.Gen).Obj = Pop{t}.Objs;
                Algo.Result(t, Algo.Gen).CV = Pop{t}.CVs;
                Algo.Result(t, Algo.Gen).Dec = Pop{t}.Decs;
            end
        end
        Algo.FE_Gen(Algo.Gen) = Algo.FE;
        Algo.Gen = Algo.Gen + 1;
    end

    function [Pop, Flag] = Evaluation(Algo, Pop, Prob, t)
        lenPop = length(Pop);
        PopDec = max(0, min(1, Pop.Decs));
        x = repmat(Prob.Ub{t} - Prob.Lb{t}, lenPop, 1) .* ...
            PopDec(:, 1:Prob.D(t)) + repmat(Prob.Lb{t}, lenPop, 1);
        [Objs, Cons] = Prob.Fnc{t}(x);
        for i = 1:lenPop
            Pop(i).Obj = Objs(i, :);
            Pop(i).CV = sum(Cons(i, :));
        end
        Algo.FE = Algo.FE + lenPop;

        if max(Prob.M) == 1 % Single-objective
            % Update Best
            if isempty(Algo.Best)
                for k = 1:Prob.T
                    Algo.Best{k} = Individual.empty();
                end
            end
            [~, ~, idx] = min_FP([Pop.Obj], [Pop.CV]);
            BestTemp = Individual();
            BestTemp.Dec = Pop(idx).Dec;
            BestTemp.Obj = Pop(idx).Obj;
            BestTemp.CV = Pop(idx).CV;
            BestTemp = [BestTemp, Algo.Best{t}];
            [~, ~, idx] = min_FP([BestTemp.Obj], [BestTemp.CV]);
            Algo.Best{t} = BestTemp(idx);
            % Set Best Update Flag
            if idx == 1
                Flag = true;
            else
                Flag = false;
            end
        else % Multi-objective
            Flag = false;
        end
    end
end

methods (Abstract)
    run(Algo, Prob) % run this tasks with algorithm,
end
end
