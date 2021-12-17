% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%           xming.hsueh@my.cityu.edu.hk
%
% ------------
% Description:
% ------------
% AT_Transfer - This function conducts a source-target affine transformation
% and transfers a solution from the source domain into the target domain.
%
% Note 1: The source-target instances are in the unified search space, so they
% have the same dimensionality.
%
% Note 2: This mapping component can be embedded into other EMT framework
% with ease
%
% -------
% Inputs:
% -------
%    source_solution : an individual from the source domain
%
%    mu_s : the mean of source Gaussian model
%
%    Sigma_s : the diagonal covariance matrix of source Gaussian model
%
%    mu_t : the mean of target Gaussian model
%
%    Sigma_t : the diagonal covariance matrix of target Gaussian model
%
% --------
% Outputs:
% --------
%    solution_transfer : a solution to be transferred to the target domain

function solution_transfer = AT_Transfer(source_solution, mu_s, Sigma_s, mu_t, Sigma_t)

    Lsi_l = chol(inv(Sigma_s));
    Lci_l = chol(inv(Sigma_t));
    Am_l = inv(Lci_l') * Lsi_l;
    bm_l = mu_t' - Am_l * mu_s';
    solution_transfer = transpose(Am_l * source_solution' + bm_l);

end
