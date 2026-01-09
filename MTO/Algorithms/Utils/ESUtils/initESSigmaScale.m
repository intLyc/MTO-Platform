function scale = initESSigmaScale(Prob, t)
% Initialize the sigma scale for task t
if isprop(Prob, 'initSigmaScale') && ~isempty(Prob.initSigmaScale{t})
    scale = Prob.initSigmaScale{t};
else
    scale = 1;
end
end
