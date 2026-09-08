function index = StreamFitnessRoulette(scores)
% Use inverse-objective roulette; shift scores and add a small offset to avoid division by zero.
scores = scores(:);
weights = cumsum(1 ./ (scores - min(min(scores), 0) + 1e-6));
index = find(rand <= weights / weights(end), 1);
end
