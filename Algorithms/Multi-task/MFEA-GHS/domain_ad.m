function [M] = domain_ad(population, Tasks)
    M = {};
    for t = 1:length(Tasks)
        population_t = population([population.skill_factor] == t);
        T = [];

        N = unidrnd(length(Tasks));
        for i = 1:N
            T = [T; population_t(i).Dec];
        end
        mean_T = mean(T);
        M{t} = (mean_T + 1e-10) ./ (mean_T + 1e-10);
    end
end
