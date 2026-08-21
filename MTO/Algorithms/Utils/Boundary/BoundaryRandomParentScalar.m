function value = BoundaryRandomParentScalar(value, parentValue, Prob)
% BoundaryRandomParentScalar - Scalar parent-to-bound random repair
%
% Upper and lower checks remain sequential to match the original local
% search implementations and their random-number ordering.

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

value = real(value);
parentValue = real(parentValue);
if nargin >= 3 && ~Prob.Bounded
    return;
end

if value > 1
    value = parentValue + rand() * (1 - parentValue);
end
if value < 0
    value = 0 + rand() * (parentValue - 0);
end
end
