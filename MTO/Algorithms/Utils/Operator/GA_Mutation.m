function Dec = GA_Mutation(Dec, mu, varargin)
% Polynomial mutation

D = size(Dec, 2);

if nargin == 2
    prob_m = 1 / D;
else
    prob_m = varargin{1};
end

for d = 1:D
    if rand() < prob_m
        u = rand(1);
        if u <= 0.5
            delta = ((2 * u + (1 - 2 * u) * (1 - Dec(d))^(mu + 1)))^(1 / (mu + 1)) - 1;
            Dec(d) = Dec(d) + delta;
        else
            delta = 1 - (2 * (1 - u) + 2 * (u - 0.5) * Dec(d)^(mu + 1))^(1 / (mu + 1));
            Dec(d) = Dec(d) + delta;
        end
    end
end
end
