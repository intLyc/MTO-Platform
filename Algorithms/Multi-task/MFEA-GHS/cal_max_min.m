function [max_T, min_T] = cal_max_min(population, Tasks)
    max_T = {};
    min_T = {};
    for t = 1:length(Tasks)
        rnvec_t = [];
        population_t = population([population.skill_factor] == t);
        for i = 1:length(population_t)
            rnvec_t = [rnvec_t; population_t(i).rnvec];
        end
        max_T{t} = max(rnvec_t);
        min_T{t} = min(rnvec_t);
    end
end
