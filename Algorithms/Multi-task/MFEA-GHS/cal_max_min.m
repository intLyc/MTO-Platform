function [max_T, min_T] = cal_max_min(population, Tasks)
    max_T = {};
    min_T = {};
    for t = 1:length(Tasks)
        Dec_t = [];
        population_t = population([population.skill_factor] == t);
        for i = 1:length(population_t)
            Dec_t = [Dec_t; population_t(i).Dec];
        end
        max_T{t} = max(Dec_t);
        min_T{t} = min(Dec_t);
    end
end
