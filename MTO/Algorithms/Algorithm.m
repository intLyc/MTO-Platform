classdef Algorithm < handle
%% Algorithm Base Class
% Inherit the Algorithm class and implement the abstract functions

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties
    Name char % Algorithm Name
    FE double = 0 % Function evaluations
    Gen double = 1 % Generations
    FE_Gen double % FE in each Gen
    Best cell % Best individual found
    Mean cell % Mean of distribution
    Result struct % Result structure array
    Result_Num double % Convergence Results Num
    Save_Dec logical = false % Save Decision Variables Flag
    Check_Status_Fn = @(varargin)[]
    Draw_Dec logical = false
    Draw_Obj logical = false
    dpd % DrawPopDec Object
    dpo % DrawPopObj Object
end

methods
    function Algo = Algorithm(name)
        % Algorithm constructor, cannot be changed
        if nargin > 0 && ~isempty(name)
            Algo.Name = name;
        else
            Algo.Name = strrep(class(Algo), '_', '-');
        end
        Algo.reset();
    end

    function reset(Algo)
        Algo.FE = 0;
        Algo.Gen = 1;
        Algo.FE_Gen = [];
        Algo.Best = {};
        Algo.Result = struct('Obj', {}, 'CV', {}, 'Dec', {});
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
        % Get the final result after the run
        Result = gen2eva(Algo.Result, Algo.FE_Gen, Algo.Result_Num);
        if Algo.Save_Dec
            maxD = max(Prob.D);
            for t = 1:size(Result, 1)
                currLb = Prob.Lb{t};
                currUb = Prob.Ub{t};
                currD = Prob.D(t);
                Range = currUb - currLb;
                for idx = 1:size(Result, 2)
                    DecNorm = Result(t, idx).Dec;
                    RealDec = currLb + DecNorm(:, 1:currD) .* Range;
                    if currD < maxD
                        ExtendedDec = nan(size(RealDec, 1), maxD);
                        ExtendedDec(:, 1:currD) = RealDec;
                        Result(t, idx).Dec = ExtendedDec;
                    else
                        Result(t, idx).Dec = RealDec;
                    end
                end
            end
        else
            Result = rmfield(Result, 'Dec');
        end
    end

    function drawInit(Algo, Prob)
        if Algo.Draw_Dec
            Algo.dpd = DrawPopDec(Algo, Prob);
        end
        if Algo.Draw_Obj && min(Prob.M) > 1
            Algo.dpo = DrawPopObj(Algo, Prob);
        end
    end

    function flag = notTerminated(Algo, Prob, Pop)
        if nargin > 2 && ~isempty(Pop)
            % Update Visualization
            if Algo.Draw_Dec && ~isempty(Algo.dpd)
                Algo.dpd.update(Algo, Prob, Pop);
                drawnow('limitrate');
            end
            if Algo.Draw_Obj && ~isempty(Algo.dpo)
                Algo.dpo.update(Algo, Prob, Pop);
                drawnow('limitrate');
            end
        end

        % Check Termination Condition
        if Algo.FE <= 0
            flag = true;
            return;
        end
        flag = Algo.FE < Prob.maxFE;

        gen = Algo.Gen;
        isSingleObj = max(Prob.M) == 1;
        for t = 1:Prob.T
            if isSingleObj
                % Single-objective: Record Best solution
                bestSol = Algo.Best{t};
                Algo.Result(t, gen).Obj = bestSol.Obj;
                Algo.Result(t, gen).CV = bestSol.CV;
                Algo.Result(t, gen).Dec = bestSol.Dec;
            else
                % Multi-objective: Record Population
                popSol = Pop{t};
                Algo.Result(t, gen).Obj = popSol.Objs;
                Algo.Result(t, gen).CV = popSol.CVs;
                Algo.Result(t, gen).Dec = popSol.Decs;
            end
        end
        % Stage update
        Algo.FE_Gen(gen) = Algo.FE;
        Algo.Gen = Algo.Gen + 1;

        drawnow('limitrate');
        Algo.Check_Status_Fn();
    end

    function [Pop, Flag] = Evaluation(Algo, Pop, Prob, t)
        % Mapping Decision Variables to Real Values
        lenPop = length(Pop);
        D = Prob.D(t);
        Decs = Pop.Decs;
        % Range scaling: x = Dec * (Ub - Lb) + Lb
        % Assumes Ub/Lb are row vectors (1xD) and Decs is (NxD)
        Range = Prob.Ub{t} - Prob.Lb{t};
        Lower = Prob.Lb{t};
        x = Decs(:, 1:D) .* Range + Lower;

        % Re-evaluate the best solution found so far for noisy problems
        reEvalMode = Prob.ReEvalBest && max(Prob.M) == 1;
        if reEvalMode
            EvalDec = [];
            if ~isempty(Algo.Mean) && ~isempty(Algo.Mean{t}) % Evolution Strategy
                EvalDec = Algo.Mean{t};
            elseif ~isempty(Algo.Best) && ~isempty(Algo.Best{t}) % Population-based EA
                EvalDec = Algo.Best{t}.Dec;
            end
            if ~isempty(EvalDec)
                EvalX = EvalDec(1:D) .* Range + Lower;
                x = [x; EvalX]; % Append to end
            else
                reEvalMode = false; % Fallback if no best exists yet
            end
        end

        % Problem Evaluation
        [Objs, Cons] = Prob.evaluate(x, t);
        % Update FE count based on actual evaluations performed
        Algo.FE = Algo.FE + size(x, 1);

        % Update Population
        PopObjs = Objs(1:lenPop, :);
        PopCons = Cons(1:lenPop, :);
        PopCVs = sum(max(0, PopCons), 2);
        objCell = num2cell(PopObjs, 2);
        conCell = num2cell(PopCons, 2);
        cvCell = num2cell(PopCVs, 2);
        [Pop.Obj] = objCell{:};
        [Pop.Con] = conCell{:};
        [Pop.CV] = cvCell{:};

        % Update Global Best (Single-objective)
        Flag = false;
        if max(Prob.M) == 1
            % Initialize Best if empty
            if isempty(Algo.Best)
                Algo.Best = cell(1, Prob.T);
            end
            [~, ~, idx] = min_FP(PopObjs, PopCVs);
            bestInPop = Pop(idx);

            % Update re-evaluated best solution
            if reEvalMode && ~isempty(Algo.Best{t})
                Algo.Best{t}.Dec = EvalDec;
                Algo.Best{t}.Obj = Objs(end, :);
                Algo.Best{t}.Con = Cons(end, :);
                Algo.Best{t}.CV = sum(max(0, Cons(end, :)));
            end

            % Final Comparison
            if isempty(Algo.Best{t})
                Algo.Best{t} = bestInPop;
                Flag = true;
            else
                oldBest = Algo.Best{t};
                candObjs = [bestInPop.Obj; oldBest.Obj];
                candCVs = [bestInPop.CV; oldBest.CV];
                [~, ~, bestIdx] = min_FP(candObjs, candCVs);
                if bestIdx == 1 % New best found
                    Algo.Best{t} = bestInPop;
                    Flag = true;
                end
            end
        end
    end
end

methods (Abstract)
    run(Algo, Prob) % run this tasks with algorithm,
end
end
