% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%           xming.hsueh@my.cityu.edu.hk
%
% ------------
% Description:
% ------------
% InitialDistribution - This function is used to build multiple Gaussian
% representation models for the given multitasking problem.

function [mu_tasks, Sigma_tasks] = InitialDistribution(population, no_of_tasks)

    mu_tasks = cell(1, no_of_tasks);
    Sigma_tasks = cell(1, no_of_tasks);

    for i = 1:no_of_tasks
        individuals = [];
        fitness = [];
        for j = 1:length(population)
            if population(j).skill_factor == i
                fitness = [fitness; population(j).factorial_costs(i)];
                individuals = [individuals; population(j).rnvec];
            end
        end
        mu_tasks{i} = mean(individuals);
        Sigma_tasks{i} = cov(individuals);
        Sigma_tasks{i} = diag(diag(Sigma_tasks{i})); % diagonalization
    end
end
