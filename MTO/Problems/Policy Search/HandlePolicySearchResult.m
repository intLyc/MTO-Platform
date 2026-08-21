function HandlePolicySearchResult(Algo, Prob)
% Print and save policy-search results for Gym and Brax problems

isPolicyProblem = contains(class(Prob), 'MaT_Gym') || ...
    contains(class(Prob), 'MaT_Brax');
if ~isPolicyProblem
    return;
end

for t = 1:Prob.T
    fprintf('%s, %.2f%%, %s, %s T%d: %.4g\n', ...
        datestr(now, 'mm-dd HH:MM:SS'), 100 * Algo.FE / Prob.maxFE, ...
        Algo.Name, Prob.Name, t, -Algo.Best{t}.Obj);
end
if Algo.FE < Prob.maxFE
    return;
end

timestamp = datestr(now, 'yyyymmdd_HHMMSS');
Dec = nan(Prob.T, max(Prob.D));
for t = 1:Prob.T
    realDec = Algo.Best{t}.Dec(1:Prob.D(t)) .* ...
        (Prob.Ub{t} - Prob.Lb{t}) + Prob.Lb{t};
    Dec(t, 1:Prob.D(t)) = realDec;
end

normalizer = cell(1, Prob.T);
for t = 1:Prob.T
    if contains(class(Prob), 'MaT_Gym')
        envName = char(Prob.tasks(t).name);
    else
        envName = Prob.envNames{t};
    end
    normalizer{t}.name = envName;
    normalizer{t}.mean = double(Prob.ObsMean{t});
    normalizer{t}.std = double(Prob.ObsStd{t});
    normalizer{t}.hiddenLayers = double(Prob.hiddenLayers);
    normalizer{t}.hiddenSize = double(Prob.hiddenSize);
end

algoNameSafe = strrep(Algo.Name, ' ', '_');
probClassPath = which(class(Prob));
if isempty(probClassPath)
    baseDir = '.';
else
    [baseDir, ~, ~] = fileparts(probClassPath);
end
targetDir = fullfile(baseDir, 'Data', algoNameSafe);
if ~exist(targetDir, 'dir')
    mkdir(targetDir);
end

decFileName = sprintf('%s/%s_Dec_%s.mat', ...
    targetDir, algoNameSafe, timestamp);
normFileName = sprintf('%s/%s_Normalizer_%s.mat', ...
    targetDir, algoNameSafe, timestamp);
save(decFileName, 'Dec');
save(normFileName, 'normalizer');
fprintf('Results saved:\n  [Dec]  %s\n  [Norm] %s\n', ...
    decFileName, normFileName);
end
