% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%           xming.hsueh@my.cityu.edu.hk
%
% ------------
% Description:
% ------------
% DistributionUpdate - This function is used to update the Gaussian
% representation models.

function [Mu, Sigma] = DistributionUpdate(Mu_old, Sigma_old, population, T)

    Mu = cell(1, T);
    Sigma = cell(1, T);
    c_Mu = 0.5;

    for t = 1:T
        individuals = [];
        % fitness = [];
        for i = 1:length(population)
            if population(i).MFFactor == t
                individuals = [individuals; population(i).Dec];
            end
        end
        Mu{t} = (1 - c_Mu) * Mu_old{t} + c_Mu * mean(individuals);
        Sigma{t} = (1 - c_Mu) * Sigma_old{t} + c_Mu * (cov(individuals) + 1e-100);
        Sigma{t} = diag(diag(Sigma{t})); % diagonalization
    end
end
