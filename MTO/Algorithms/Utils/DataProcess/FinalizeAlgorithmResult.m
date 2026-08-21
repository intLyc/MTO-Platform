function Result = FinalizeAlgorithmResult(Algo, Prob)
% Build the fixed-layout result array from recorded FE checkpoints

if isempty(Algo.Result_Buffer)
    % Compatibility path for legacy or externally populated results.
    Result = SampleResultByFE(Algo.Result, Algo.FE_Gen, Algo.Result_Num);
else
    Result = finalizeBuffer(Algo, Prob);
end

if Algo.Save_Dec
    maxD = max(Prob.D);
    for t = 1:size(Result, 1)
        currLb = Prob.Lb{t};
        currUb = Prob.Ub{t};
        currD = Prob.D(t);
        range = currUb - currLb;
        for k = 1:size(Result, 2)
            decNorm = Result(t, k).Dec;
            realDec = currLb + decNorm(:, 1:currD) .* range;
            if currD < maxD
                extendedDec = nan(size(realDec, 1), maxD);
                extendedDec(:, 1:currD) = realDec;
                Result(t, k).Dec = extendedDec;
            else
                Result(t, k).Dec = realDec;
            end
        end
    end
else
    Result = rmfield(Result, 'Dec');
end
end

function Result = finalizeBuffer(Algo, Prob)
resultNum = max(1, round(Algo.Result_Num));
available = find(Algo.Result_Buffer_FE > 0);
if isempty(available)
    Result = SampleResultByFE(Algo.Result, Algo.FE_Gen, resultNum);
    return;
end

source = zeros(1, resultNum);
lastSource = available(1);
for k = 1:resultNum
    if any(available == k)
        lastSource = k;
    end
    source(k) = lastSource;
end
Result = Algo.Result_Buffer(:, source);

if max(Prob.M) > 1
    popSizes = [Result.PopSize];
    targetSize = max([Prob.N, popSizes]);
    for t = 1:size(Result, 1)
        for k = 1:size(Result, 2)
            currentSize = Result(t, k).PopSize;
            if currentSize <= 0
                error('MToP:EmptyCheckpointPopulation', ...
                    'Multi-objective checkpoint population cannot be empty.');
            end
            index = mod(0:targetSize - 1, currentSize) + 1;
            Result(t, k).Obj = Result(t, k).Obj(index, :);
            Result(t, k).CV = Result(t, k).CV(index, :);
            if ~isempty(Result(t, k).Dec)
                Result(t, k).Dec = Result(t, k).Dec(index, :);
            end
        end
    end
end
Result = rmfield(Result, 'PopSize');
end
