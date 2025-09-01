function [obj, con] = S_Schwefel(var_m, opt)
% Schwefel 2.2 function
%   - var_m: (num x dim) design variable matrix
%   - opt:   (1 x dim) shift vector

[num, ~] = size(var_m);

diff = var_m - opt;

absDiff = abs(diff);

obj = sum(absDiff, 2) + prod(absDiff, 2);

con = zeros(num, 1);
end
