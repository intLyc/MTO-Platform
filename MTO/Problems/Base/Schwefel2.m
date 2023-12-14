function [Obj, Con] = Schwefel2(x, M, opt, g)
% SCHWEFEL function problem1.2
%   - var: design variable vector
%   - M: rotation matrix
%   - opt: shift vector
%   - g: Objective value move

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

var = x;
dim = length(var);
var = (M * (var - opt)')';
Obj = 0;
for i = 1:dim
    Obj = Obj + sum(var(1:i)).^2;
end

Obj = Obj + g;

Con = 0;
end
