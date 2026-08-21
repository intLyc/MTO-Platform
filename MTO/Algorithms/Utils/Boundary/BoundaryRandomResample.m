function Dec = BoundaryRandomResample(Dec, Prob)
% BoundaryRandomResample - Resample only dimensions outside [0, 1]
%
% The random array has exactly the size of the violation set, preserving
% the random-number consumption of the original implementations.

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

violated = Dec < 0 | Dec > 1;
Dec(violated) = rand(size(Dec(violated)));
end
