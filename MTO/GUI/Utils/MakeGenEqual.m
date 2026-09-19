function Results = MakeGenEqual(Results)
% Pad shorter repetitions with their last recorded generation.
% CV always has task-by-generation layout; MO objectives use one cell per task.
for prob = 1:size(Results, 1)
    for algo = 1:size(Results, 2)
        counts = arrayfun(@(r) size(r.CV, 2), Results(prob, algo, :));
        maxGen = max(counts);
        for rep = 1:size(Results, 3)
            record = Results(prob, algo, rep);
            count = counts(rep);
            if count == maxGen, continue; end
            if count == 0
                error('MToP:EmptyHistory', 'Cannot pad an empty result history.');
            end
            if iscell(record.Obj)
                record.Obj = cellfun(@(x) padHistory(x, 1, count, maxGen), record.Obj, 'UniformOutput', false);
            else
                record.Obj = padHistory(record.Obj, 2, count, maxGen);
            end
            record.CV = padHistory(record.CV, 2, count, maxGen);
            if isfield(record, 'Dec') && ~isempty(record.Dec)
                record.Dec = padHistory(record.Dec, 2, count, maxGen);
            end
            Results(prob, algo, rep) = record;
        end
    end
end
end
function values = padHistory(values, dimension, count, target)
indices = repmat({':'}, 1, max(ndims(values), dimension));
indices{dimension} = [1:count, repmat(count, 1, target-count)];
values = values(indices{:});
end
