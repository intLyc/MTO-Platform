function Dec = GA_Mutation(Dec, mu)
% Polynomial mutation

D = size(Dec, 2);
for d = 1:D
    if rand() < 1 / D
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
