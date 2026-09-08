function result = ConvertExperimentResult(history, multiObjective)
% Convert task-by-generation records to the MTOData result layout.

result = struct('Obj', [], 'CV', []);
saveDec = isfield(history, 'Dec');
if saveDec
    result.Dec = [];
end
if multiObjective
    result.Obj = cell(1, size(history, 1));
end
for task = 1:size(history, 1)
    for generation = 1:size(history, 2)
        record = history(task, generation);
        if multiObjective
            % Tasks may have different numbers of objectives.
            result.Obj{task}(generation, :, :) = record.Obj;
            if saveDec
                result.Dec(task, generation, :, :) = record.Dec;
            end
        else
            result.Obj(task, generation, :) = record.Obj;
            if saveDec
                result.Dec(task, generation, :) = record.Dec;
            end
        end
        result.CV(task, generation, :) = record.CV;
    end
end
end
 