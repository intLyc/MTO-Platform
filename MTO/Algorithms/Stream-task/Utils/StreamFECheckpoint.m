function yes = StreamFECheckpoint(fe, batchSize, gap)
% Detect FE interval crossings rather than exact multiples to avoid skipped checkpoints.
yes = gap > 0 && floor((fe + batchSize) / gap) > floor(fe / gap);
end
