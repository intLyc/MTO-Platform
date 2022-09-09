function [OffDec1, OffDec2] = GA_Crossover(ParDec1, ParDec2, mu)
    % SBX - Simulated binary crossover
    D = length(ParDec1);
    u = rand(1, D);
    cf = zeros(1, D);
    cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
    cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

    OffDec1 = 0.5 * ((1 + cf) .* ParDec1 + (1 - cf) .* ParDec2);
    OffDec2 = 0.5 * ((1 + cf) .* ParDec2 + (1 - cf) .* ParDec1);
end
