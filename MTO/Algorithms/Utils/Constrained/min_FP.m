function [minObj, minCV, min_idx] = min_FP(Obj, CV, ep)
% Handle optional epsilon parameter
if nargin < 3, ep = 0; end

% Apply epsilon-constraint handling
CV(CV <= ep) = 0;

% Identify the minimum constraint violation level
minCV = min(CV);

% infinity masking:
% Assign Inf to objectives of individuals that do not satisfy the minCV.
% This avoids the overhead of 'find' and index mapping.
search_obj = Obj;
search_obj(CV > minCV) = inf;

% Select the best individual (Lexicographic selection)
[minObj, min_idx] = min(search_obj);
end
