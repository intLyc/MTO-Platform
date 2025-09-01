function [obj, con] = S_Levy(var_m, opt)
% Levy function
%   - var_m: (num x d) design variable matrix
%   - opt:   (1 x d) shift vector

[num, d] = size(var_m);

% w (num x d)
w = 1 + (var_m - opt) / 4;

% term1: sin(pi*w1)^2
term1 = sin(pi * w(:, 1)).^2;

% term3: (wd-1)^2 * (1+sin(2*pi*wd)^2)
wd = w(:, d);
term3 = (wd - 1).^2 .* (1 + sin(2 * pi * wd).^2);

% sum: sum_{i=1}^{d-1} ( (wi-1)^2 * (1+10*sin(pi*wi+1)^2) )
if d > 1
    wi = w(:, 1:(d - 1));
    sumPart = (wi - 1).^2 .* (1 + 10 * sin(pi * wi + 1).^2);
    term2 = sum(sumPart, 2);
else
    term2 = zeros(num, 1);
end

obj = term1 + term2 + term3;

con = zeros(num, 1);
end
