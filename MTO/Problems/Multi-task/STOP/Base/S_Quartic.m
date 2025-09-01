function [obj, con] = S_Quartic(var_m, opt)
% Quartic function with noise
%   - var_m: (num x dim) design variable matrix
%   - opt:   (1 x dim) shift vector

[num, dim] = size(var_m);

w = 1:dim;

diff = var_m - opt;

obj = sum((diff.^4) .* w, 2) + rand(num, 1);

con = zeros(num, 1);
end
