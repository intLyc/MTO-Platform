function [required, excluded] = CatalogFilter(task, objective, constrained, competitive, stream)
% Independent dimensions are ANDed; slash capabilities are alternatives.
required = {task, objective};
if constrained, required{end+1} = 'Constrained'; end
if competitive
    required{end+1} = 'Competitive';
else
    required{end+1} = 'NonCompetitive';
    if ~constrained, required{end+1} = 'None'; end
end
excluded = {};
if stream, required{end+1} = 'Stream'; else, excluded = {'Stream'}; end
end
