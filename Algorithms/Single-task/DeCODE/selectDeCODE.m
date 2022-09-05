function [population] = selectDeCODE(population, offspring, weights)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    Obj = [[population.Obj], [offspring.Obj]];
    CV = [[population.CV], [offspring.CV]];
    normal_Obj = (Obj - min(Obj)) ./ (std(Obj) + eps(0));
    normal_CV = (CV - min(CV)) ./ (std(CV) + eps(0));

    normal_pop_obj = normal_Obj(1:length(population));
    normal_off_obj = normal_Obj(length(population) + 1:end);
    normal_pop_cv = normal_CV(1:length(population));
    normal_off_cv = normal_CV(length(population) + 1:end);

    pop_fit = weights .* normal_pop_obj + (1 - weights) .* normal_pop_cv;
    off_fit = weights .* normal_off_obj + (1 - weights) .* normal_off_cv;

    replace = pop_fit > off_fit;

    population(replace) = offspring(replace);
end
