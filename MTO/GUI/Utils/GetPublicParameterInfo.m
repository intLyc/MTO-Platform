function info = GetPublicParameterInfo(problems)
% Read current public values and locate parameters exposed by every selected problem.
propertyNames = {'N', 'maxFE', 'T', 'D'};
values = nan(numel(problems), 4);
info.Indices = zeros(numel(problems), 4);
for n = 1:numel(problems)
    problem = problems{n};
    for p = 1:4
        value = problem.(propertyNames{p});
        if ~isempty(value) && all(value == value(1))
            values(n, p) = value(1);
        end
    end
    parameters = problem.getParameter();
    for i = 1:2:numel(parameters)
        % Match complete names or prefixes before ':', not arbitrary substrings.
        key = lower(regexprep(parameters{i}, ':.*$', ''));
        key = regexprep(key, '[^a-z0-9]', '');
        switch key
            case {'n', 'populationsize'}
                p = 1;
            case 'maxfe'
                p = 2;
            case {'t', 'tasknum', 'tasknumber', 'numberoftasks'}
                p = 3;
            case {'d', 'dim', 'dims', 'dimension', 'dimensions', 'armdimension'}
                p = 4;
            otherwise
                continue;
        end
        value = str2double(parameters{i+1});
        if isscalar(value) && isfinite(value)
            values(n, p) = value;
            info.Indices(n, p) = i + 1;
        end
    end
end
info.Values = nan(1, 4);
info.Editable = false(1, 4);
if isempty(problems), return; end
for p = 1:4
    if all(values(:, p) == values(1, p)), info.Values(p) = values(1, p); end
    info.Editable(p) = all(info.Indices(:, p) > 0);
end
end
