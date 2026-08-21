function RecordAlgorithmResult(Algo, Prob, Pop)
% Record lightweight generation data and full FE-checkpoint data

gen = Algo.Gen;
isSingleObj = max(Prob.M) == 1;
checkpointSlots = getCheckpointSlots(Algo, Prob);
checkpoint = repmat(struct('Obj', [], 'CV', [], 'Dec', [], ...
    'PopSize', 0), 1, Prob.T);

for t = 1:Prob.T
    if isSingleObj
        bestSol = Algo.Best{t};
        Algo.Result(t, gen).Obj = bestSol.Obj;
        Algo.Result(t, gen).CV = bestSol.CV;
        Algo.Result(t, gen).Dec = [];
        if ~isempty(checkpointSlots)
            checkpoint(t).Obj = bestSol.Obj;
            checkpoint(t).CV = bestSol.CV;
            checkpoint(t).PopSize = 1;
            if Algo.Save_Dec
                checkpoint(t).Dec = bestSol.Dec;
            end
        end
    else
        popSol = Pop{t};
        if ~isempty(checkpointSlots)
            checkpoint(t).Obj = popSol.Objs;
            checkpoint(t).CV = popSol.CVs;
            checkpoint(t).PopSize = length(popSol);
            if Algo.Save_Dec
                checkpoint(t).Dec = popSol.Decs;
            end
        end

        % Preserve the fixed-size generation history used by existing algorithms.
        currentSize = length(popSol);
        if currentSize > 0 && currentSize < Prob.N
            numToAdd = Prob.N - currentSize;
            popSol = [popSol, popSol(randi(currentSize, 1, numToAdd))];
        end
        Algo.Result(t, gen).Obj = popSol.Objs;
        Algo.Result(t, gen).CV = popSol.CVs;
        Algo.Result(t, gen).Dec = [];
    end
end

for k = checkpointSlots
    for t = 1:numel(checkpoint)
        Algo.Result_Buffer(t, k) = checkpoint(t);
    end
    Algo.Result_Buffer_FE(k) = Algo.FE;
end
end

function slots = getCheckpointSlots(Algo, Prob)
% Return result slots crossed by the current FE value.

resultNum = max(1, round(Algo.Result_Num));
if resultNum == 1
    slots = 1;
    return;
end

slotMask = false(1, resultNum);
if isempty(Algo.Result_Buffer_FE) || Algo.Result_Buffer_FE(1) == 0
    slotMask(1) = true;
end
for k = 2:resultNum - 1
    isStored = numel(Algo.Result_Buffer_FE) >= k && ...
        Algo.Result_Buffer_FE(k) > 0;
    if ~isStored && Algo.FE >= k * Prob.maxFE / resultNum
        slotMask(k) = true;
    end
end
if Algo.FE >= Prob.maxFE
    slotMask(resultNum) = true;
end
slots = find(slotMask);
end
