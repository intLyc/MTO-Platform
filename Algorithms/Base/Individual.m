classdef Individual
    %% Individual Base Class

    properties
        rnvec; % gene
        factorial_costs; % object

        % multifactorial parameter
        factorial_ranks;
        scalar_fitness;
        skill_factor;
    end
end
