function match = MatchCatalogLabels(header, required, excluded)
% Header slash lists declare supported alternatives, not a query-wide OR.
% Queries require ALL selected tokens and NONE of the excluded tokens.
% A nested required cell is an explicit ANY-of group (for programmatic callers).
if nargin < 3, excluded = {}; end
if ischar(required) || isstring(required), required = cellstr(required); end
if ischar(excluded) || isstring(excluded), excluded = cellstr(excluded); end
if ~ischar(header), match = false; return; end
groups = regexp(header, '(?<=<)[^<>]*(?=>)', 'match');
labels = {};
for i = 1:numel(groups)
    labels = [labels, strtrim(strsplit(groups{i}, '/'))]; %#ok<AGROW>
end
% Legacy None/Competitive explicitly supports both execution modes.
if ~ismember('Competitive',labels) || ismember('None',labels)
    labels{end+1} = 'NonCompetitive';
end
match = ~isempty(groups) && ~any(ismember(excluded, labels));
for i = 1:numel(required)
    match = match && any(ismember(required{i}, labels));
end
end
