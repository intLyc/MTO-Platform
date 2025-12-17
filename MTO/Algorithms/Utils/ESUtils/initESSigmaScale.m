function scale = initESSigmaScale(Prob)
% Initialize the sigma scale for task t
if isprop(Prob, 'initSigmaScale') && ~isempty(Prob.initSigmaScale)
    scale = Prob.initSigmaScale;
else
    scale = 1;
end
end
