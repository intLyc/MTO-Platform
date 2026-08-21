function Dec = BoundaryMidpoint(Dec, ParentDec, Prob)
% BoundaryMidpoint - Move violated dimensions halfway toward a parent

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

Dec = real(Dec);
ParentDec = real(ParentDec);
if nargin >= 3 && ~Prob.Bounded
    return;
end

vioLow = Dec < 0;
Dec(vioLow) = (ParentDec(vioLow) + 0) / 2;
vioUp = Dec > 1;
Dec(vioUp) = (ParentDec(vioUp) + 1) / 2;
end
