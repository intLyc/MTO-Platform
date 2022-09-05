function [population, calls, bestDec, bestObj, bestCV] = initialize(Individual_class, pop_size, Task, dim, varargin)
    %% Initialize and evaluate the population
    % Input: Individual_class, pop_size, Task, dim
    % Output: population, calls (function calls number)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    n = numel(varargin);
    if n == 0
        gene_type = 'unified'; % unified [0, 1]
    elseif n == 1
        gene_type = varargin{1};
    end

    for i = 1:pop_size
        population(i) = Individual_class();
        switch gene_type
            case 'unified'
                population(i).Dec = rand(1, dim);
            case 'real'
                population(i).Dec = (Task.Ub - Task.Lb) .* rand(1, dim) + Task.Lb;
        end

    end
    [population, calls] = evaluate(population, Task, 1, gene_type);

    [bestObj, bestCV, idx] = min_FP([population.Obj], [population.CV]);
    bestDec = population(idx).Dec;
end
