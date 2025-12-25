function Dec = GA_Mutation(Dec, mu, prob_m)
% Polynomial mutation

D = size(Dec, 2);

if nargin < 3
    prob_m = 1 / D;
end

% Generate Mutation Mask
Mask = rand(size(Dec)) < prob_m;
if ~any(Mask), return; end

% Perform Mutation
checkDec = Dec(Mask);
% Calculate delta
u = rand(size(checkDec));
delta = zeros(size(checkDec));
idx1 = u <= 0.5;
if any(idx1)
    val1 = 2 * u(idx1) + (1 - 2 * u(idx1)) .* (1 - checkDec(idx1)).^(mu + 1);
    delta(idx1) = val1.^(1 / (mu + 1)) - 1;
end
idx2 = ~idx1;
if any(idx2)
    val2 = 2 * (1 - u(idx2)) + 2 * (u(idx2) - 0.5) .* checkDec(idx2).^(mu + 1);
    delta(idx2) = 1 - val2.^(1 / (mu + 1));
end
% Update Dec
Dec(Mask) = Dec(Mask) + delta;
end
