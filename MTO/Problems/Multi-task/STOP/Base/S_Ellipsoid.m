function [obj, con] = S_Ellipsoid(var_m, opt)
% Ellipsoid function
%   - var_m: (num x dim) design variable matrix
%   - opt:   (1 x dim) shift vector

[num, dim] = size(var_m);

w = dim:-1:1;

diff = var_m - opt;

obj = sum((diff.^2) .* w, 2);

con = zeros(num, 1);
end
