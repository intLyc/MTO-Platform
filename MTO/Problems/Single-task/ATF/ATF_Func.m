function [Obj, Con] = ATF_Func(var, problem)

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

[ps, D] = size(var);
Obj = repmat(10 * D, ps, 1);
for i = 1:D
    Obj = Obj + (var(:, i).^2 - 10 * (cos(2 * pi * var(:, i))));
end
switch problem
    case 1
        Con = var(:, 1).^2/4 + var(:, 2).^2/9 -1;
    case 2
        Con = 3 * (var(:, 1) + 9).^2 + var(:, 2).^2 - 2;
end
Con(Con < 0) = 0;
end
