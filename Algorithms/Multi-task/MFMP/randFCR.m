function [F,CR] = randFCR(NP, CRm, CRsigma, Fm,  Fsigma)

% this function generate CR according to a normal distribution with mean "CRm" and sigma "CRsigma"
%           If CR > 1, set CR = 1. If CR < 0, set CR = 0.
% this function generate F  according to a cauchy distribution with location parameter "Fm" and scale parameter "Fsigma"
%           If F > 1, set F = 1. If F <= 0, regenrate F.
%
% Version: 1.1   Date: 11/20/2007
% Written by Jingqiao Zhang (jingqiao@gmail.com)

%% generate CR
CR = CRm + CRsigma * randn(NP, 1);
CR = min(1, max(0, CR));                % truncated to [0 1]

%% generate F
F = randCauchy(NP, 1, Fm, Fsigma);
F = min(1, F);                          % truncation

% we don't want F = 0. So, if F<=0, we regenerate F (instead of trucating it to 0)
pos = find(F <= 0);
while ~ isempty(pos)
    F(pos) = randCauchy(length(pos), 1, Fm, Fsigma);
    F = min(1, F);                      % truncation
    pos = find(F <= 0);
end

% Cauchy distribution: cauchypdf = @(x, mu, delta) 1/pi*delta./((x-mu).^2+delta^2)
function result = randCauchy(m, n, mu, delta)

% http://en.wikipedia.org/wiki/Cauchy_distribution
result = mu + delta * tan(pi * (rand(m, n) - 0.5));
