function ready = StreamInitializePopulation(Algo, Prob, t, IndividualClass, warmStart)
% Resume initialization; warmStart enables past-task transfer and ready marks completion.
%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

if isempty(Algo.State{t})
    % Sources need full populations and may be completed; initialize the first arrival group randomly.
    donors = find(cellfun(@numel, Algo.Population) >= Prob.N);
    donors(donors == t) = [];
    if ~warmStart || Prob.Arrival(t) == min(Prob.Arrival), donors = []; end
    donors = donors(1:min(numel(donors), Prob.N));
    % Use the maximum task dimension; evaluation selects each task's valid coordinates.
    batch = repmat(IndividualClass(), 1, Prob.N);
    for i = 1:Prob.N, batch(i).Dec = rand(1, max(Prob.D)); end
    Algo.Population{t} = batch([]);
    Algo.State{t} = struct('Stage', 1, 'Batch', batch, 'Offset', 0, ...
        'Donors', donors, 'Context', struct());
end
% Stage: 1 random evaluation, 2 source probes, 3 transfer reevaluation, 4 ready.
% Offset tracks evaluated candidates so the current stage can resume after arrivals.
s = Algo.State{t};
if s.Stage == 1
    pop = Algo.Evaluation(s.Batch(s.Offset + 1:end), Prob, t);
    Algo.Population{t} = [Algo.Population{t}, pop];
    s.Offset = s.Offset + numel(pop);
    if s.Offset == Prob.N
        s.Batch = []; s.Offset = 0;
        if isempty(s.Donors), s.Stage = 4; else, s.Stage = 2; end
    end
elseif s.Stage == 2
    i = s.Offset + 1;
    pop = Algo.Population{t}(i);
    pop.Dec = Algo.Population{s.Donors(i)}(1).Dec;
    Algo.Population{t}(i) = Algo.Evaluation(pop, Prob, t);
    s.Offset = i;
    if i == numel(s.Donors)
        % Preserve the author's loop bounds, including overwriting probe slot L.
        for j = numel(s.Donors):round(Prob.N / 2) - numel(s.Donors)
            source = s.Donors(StreamFitnessRoulette(Algo.Population{t}(1:numel(s.Donors)).Objs));
            Algo.Population{t}(j).Dec = Algo.Population{source}(randi(Prob.N)).Dec;
        end
        s.Stage = 3; s.Offset = 0;
    end
else
    % Reevaluate modified decisions and count these calls toward FE.
    pop = Algo.Evaluation(Algo.Population{t}(s.Offset + 1:end), Prob, t);
    Algo.Population{t}(s.Offset + (1:numel(pop))) = pop;
    s.Offset = s.Offset + numel(pop);
    if s.Offset == Prob.N, s.Stage = 4; s.Offset = 0; end
end
if s.Stage == 4
    Algo.Shared.Ready(t) = true;
end
Algo.State{t} = s;
ready = Algo.Shared.Ready(t);
end
