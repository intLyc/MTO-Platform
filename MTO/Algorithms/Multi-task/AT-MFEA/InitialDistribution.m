% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%           xming.hsueh@my.cityu.edu.hk
%
% ------------
% Description:
% ------------
% InitialDistribution - This function is used to build Multiple Gaussian
% representation models for the given Multitasking problem.

function [Mu_tasks, Sigma_tasks] = InitialDistribution(population, T)

    Mu_tasks = cell(1, T);
    Sigma_tasks = cell(1, T);

    for t = 1:T
        individuals = [];
        % fitness = [];
        for i = 1:length(population)
            if population(i).MFFactor == t
                individuals = [individuals; population(i).Dec];
            end
        end
        Mu_tasks{t} = mean(individuals);
        Sigma_tasks{t} = cov(individuals);
        Sigma_tasks{t} = diag(diag(Sigma_tasks{t})); % diagonalization
    end
end
