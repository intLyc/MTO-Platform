function [population, rank] = Selection_Elit(population, offspring, varargin)
    %% Elite selection
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

    N = length(population);
    population = [population, offspring];
    CV = [population.CV]; CV(CV < Ep) = 0;
    Obj = [population.Obj];
    [~, rank] = sortrows([CV', Obj'], [1, 2]);
    population = population(rank(1:N));
end
