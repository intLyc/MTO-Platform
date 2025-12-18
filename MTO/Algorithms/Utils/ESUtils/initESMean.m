function x = initESMean(Prob, t)
% Initialize the mean solution for task t
if isprop(Prob, 'initSolutionMean') && ~isempty(Prob.initSolutionMean{t})
    x = Prob.initSolutionMean{t};
    x = (x - Prob.Lb{t}) ./ (Prob.Ub{t} - Prob.Lb{t});
else
    x = rand(1, Prob.D(t));
end
end
