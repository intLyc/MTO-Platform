function [population] = selectCORCO(population, offspring, weights)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    Obj = [[population.factorial_costs], [offspring.factorial_costs]];
    CV = [[population.constraint_violation], [offspring.constraint_violation]];
    normal_Obj = (Obj - min(Obj)) ./ (max(Obj) - min(Obj) + 1e-15);
    normal_CV = (CV - min(CV)) ./ (max(CV) - min(CV) + 1e-15);

    normal_pop_obj = normal_Obj(1:length(population));
    normal_off_obj = normal_Obj(length(population) + 1:end);
    normal_pop_cv = normal_CV(1:length(population));
    normal_off_cv = normal_CV(length(population) + 1:end);

    pop_fit = weights .* normal_pop_obj + (1 - weights) .* normal_pop_cv;
    off_fit = weights .* normal_off_obj + (1 - weights) .* normal_off_cv;

    replace = pop_fit > off_fit;

    population(replace) = offspring(replace);
end
