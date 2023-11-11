function [Obj, Con] = Elliptic(x, M, opt, g)
% Elliptic function
%   - var: design variable vector
%   - M: rotation matrix
%   - opt: shift vector
%   - g: Objective value move

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

var = x;
dim = length(var);
var = (M * (var - opt)')';
a = 1e+6;
Obj = 0;
for i = 1:dim
    Obj = Obj + a.^((i - 1) / (dim - 1)) .* var(i).^2;
end
Obj = Obj + g;

Con = 0;
end
