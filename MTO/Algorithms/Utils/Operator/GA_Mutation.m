function Dec = GA_Mutation(Dec, mu)
% Polynomial mutation
for d = 1:length(Dec)
    if rand(1) < 1 / length(Dec)
        u = rand(1);
        if u <= 0.5
            del = (2 * u)^(1 / (1 + mu)) - 1;
            Dec(d) = Dec(d) + del * (Dec(d));
        else
            del = 1 - (2 * (1 - u))^(1 / (1 + mu));
            Dec(d) = Dec(d) + del * (1 - Dec(d));
        end
    end
end
end
