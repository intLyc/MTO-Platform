classdef Individual
    properties
        rnvec; % gene
        factorial_costs; % object

        % multifactorial
        factorial_ranks;
        scalar_fitness;
        skill_factor;

        % pso
        pbest;
        pbestFitness;
        velocity;
    end
end
