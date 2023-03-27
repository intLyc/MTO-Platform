function kl = mvgkl(m1, m2, S1, S2)

% Provided by Jiang, Yi

S1 = S1 +1e-6 * eye(size(S1));
S2 = S2 +1e-6 * eye(size(S1));
% d-variate Gaussian
d = length(m1);

[R1, P1] = cholcov(S1, 0); % Cholesky decomposition of covariance matrices
[R2, P2] = cholcov(S2, 0);

if (any([P1, P2]) || any(isnan([P1, P2])))
    error('covariance matrices are not positive definite');
end

%% Compute KL divergence
sqTerm = sum(((m2 - m1)' / R2).^2); % Squared term

logDetS1 = 2 * sum(log(diag(R1))); % log |S1|
logDetS2 = 2 * sum(log(diag(R2))); % log |S2|

% KL divergence
kl = trace(R2 \ (R2' \ S1)) + sqTerm - d + logDetS2 - logDetS1;
kl = kl / 2;

end
