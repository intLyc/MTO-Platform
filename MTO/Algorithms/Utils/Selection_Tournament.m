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

    replace_cv = population.CVs > offspring.CVs & ...
        population.CVs > Ep & offspring.CVs > Ep;
    equal_cv = population.CVs <= Ep & offspring.CVs <= Ep;
    replace_f = population.Objs > offspring.Objs;
    replace = (equal_cv & replace_f) | replace_cv;
    replace = replace';
    population(replace) = offspring(replace);
end
