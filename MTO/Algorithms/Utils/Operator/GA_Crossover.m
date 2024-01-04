function [OffDec1, OffDec2] = GA_Crossover(ParDec1, ParDec2, mu)
% SBX - Simulated binary crossover

D = size(ParDec1, 2);
u = rand(1, D);
beta = zeros(1, D);
beta(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
beta(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
beta = beta .* (-1).^randi([0, 1], 1, D);
beta(rand(1, D) < 0.5) = 1;

OffDec1 = 0.5 * ((1 + beta) .* ParDec1 + (1 - beta) .* ParDec2);
OffDec2 = 0.5 * ((1 + beta) .* ParDec2 + (1 - beta) .* ParDec1);
end
