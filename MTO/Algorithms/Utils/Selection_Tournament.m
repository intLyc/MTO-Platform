function [population, replace] = Selection_Tournament(population, offspring, varargin)
    %% Tournament selection
    % Input: population (old), offspring, epsilon (constraint)
    % Output: population (new)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    n = length(varargin);
    if n == 0
        Ep = 0;
    elseif n == 1
        Ep = varargin{1};
    end

    replace_cv = [population.CV] > [offspring.CV] & ...
        [population.CV] > Ep & [offspring.CV] > Ep;
    equal_cv = [population.CV] <= Ep & [offspring.CV] <= Ep;
    replace_f = [population.Obj] > [offspring.Obj];
    replace = (equal_cv & replace_f) | replace_cv;
    population(replace) = offspring(replace);
end
