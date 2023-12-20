%DEFPARAM a script to handle the parameters passed to a function.
%   set the variables outside the struct PARAM for all its fields. Maybe
%   overwites the previously defined default value of the variable.
%	e.g., if PARAM.a=1, then set a variable a=1 outside PARAM.

if ~exist('param','var')
	param = [];
end
if isempty(param)
	return
end
if ~isstruct(param) || length(param) ~= 1
	error('PARAM should be a struct with length 1')
end

fns = fieldnames(param);
for iFn = 1:length(fns)
	eval(sprintf('%s=param.%s;',fns{iFn},fns{iFn}))
end