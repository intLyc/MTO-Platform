function [state, complete] = StreamEvaluateBatch(Algo, Prob, t, state)
% Resume the batch at Offset and retain pending candidates across arrival events.
%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

[evaluated, improved] = Algo.Evaluation(state.Batch(state.Offset + 1:end), Prob, t);
state.Batch(state.Offset + (1:numel(evaluated))) = evaluated;
state.Offset = state.Offset + numel(evaluated);
% Accumulate best-solution improvements for the reward update after batch completion.
state.Context.Improved = state.Context.Improved || improved;
% Select and adapt only after the batch finishes or the task budget is exhausted.
complete = state.Offset == numel(state.Batch) || Algo.TaskFE(t) >= Prob.TaskBudget(t);
end
