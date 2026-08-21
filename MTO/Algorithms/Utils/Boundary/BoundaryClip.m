function Dec = BoundaryClip(Dec, Prob)
% BoundaryClip - Convert decisions to real values and clip bounded problems
%
% If Prob is omitted, clipping is unconditional. Passing Prob preserves
% algorithms that only apply boundary handling when Prob.Bounded is true.

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

Dec = real(Dec);
if nargin < 2 || Prob.Bounded
    Dec = max(0, min(1, Dec));
end
end
