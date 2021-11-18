% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%           xming.hsueh@my.cityu.edu.hk
%
% ------------
% Description:
% ------------
% DistributionUpdate - This function is used to update the Gaussian
% representation models.

function [mu, Sigma] = DistributionUpdate(mu_old, Sigma_old, population, no_of_tasks)

    mu = cell(1, no_of_tasks);
    Sigma = cell(1, no_of_tasks);
    c_mu = 0.5;

    for i = 1:no_of_tasks
        individuals = [];
        fitness = [];
        for j = 1:length(population)
            if population(j).skill_factor == i
                fitness = [fitness; population(j).factorial_costs(i)];
                individuals = [individuals; population(j).rnvec];
            end
        end
        mu{i} = (1 - c_mu) * mu_old{i} + c_mu * mean(individuals);
        Sigma{i} = (1 - c_mu) * Sigma_old{i} + c_mu * cov(individuals);
        Sigma{i} = diag(diag(Sigma{i})); % diagonalization
    end
end
