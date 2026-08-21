function Dec = BoundaryRandomParent(Dec, ParentDec, Prob)
% BoundaryRandomParent - Randomly move violations between parent and bound
%
% Two full-size random arrays are generated in the same order as the
% original algorithm implementations, including when no value is violated.

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

rndLower = 0 + rand(size(ParentDec)) .* (ParentDec - 0);
vioLow = Dec < 0;
Dec(vioLow) = rndLower(vioLow);
rndUpper = ParentDec + rand(size(ParentDec)) .* (1 - ParentDec);
vioUp = Dec > 1;
Dec(vioUp) = rndUpper(vioUp);
Dec = BoundaryClip(Dec);
end
