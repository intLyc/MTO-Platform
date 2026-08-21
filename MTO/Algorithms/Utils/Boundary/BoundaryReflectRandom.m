function Dec = BoundaryReflectRandom(Dec, Prob)
% BoundaryReflectRandom - Preserve the existing reflect-or-endpoint policy
%
% Random draws intentionally occur even when no dimensions violate a bound,
% matching the original algorithm implementations exactly.

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

Dec = real(Dec);
if nargin >= 2 && ~Prob.Bounded
    return;
end

vioLow = find(Dec < 0);
if rand() < 0.5
    Dec(vioLow) = 2 * 0 - Dec(vioLow);
    vioTemp = Dec(vioLow) > 1;
    Dec(vioLow(vioTemp)) = 1;
else
    if rand() < 0.5
        Dec(vioLow) = 0;
    else
        Dec(vioLow) = 1;
    end
end

vioUp = find(Dec > 1);
if rand() < 0.5
    Dec(vioUp) = 2 * 1 - Dec(vioUp);
    vioTemp = Dec(vioUp) < 0;
    Dec(vioUp(vioTemp)) = 1;
else
    if rand() < 0.5
        Dec(vioUp) = 0;
    else
        Dec(vioUp) = 1;
    end
end
end
