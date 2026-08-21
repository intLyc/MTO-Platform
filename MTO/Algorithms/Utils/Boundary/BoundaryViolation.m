function violation = BoundaryViolation(Dec, Lower, Upper)
% BoundaryViolation - Squared distance outside the supplied interval

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

Dec = real(Dec);
if nargin < 2, Lower = 0; end
if nargin < 3, Upper = 1; end
clippedDec = max(Lower, min(Upper, Dec));
violation = sum((Dec - clippedDec).^2);
end
