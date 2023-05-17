function M = RandOrthMat(n, k)
% M = RANDORTHMAT(n)
% generates a random n x n orthogonal real matrix.
%
% M = RANDORTHMAT(n,tol)
% explicitly specifies a thresh value that measures linear dependence
% of a newly formed column with the existing columns. Defaults to 1e-6.
%
% In this version the generated matrix distribution *is* uniform over the manifold
% O(n) w.r.t. the induced R^(n^2) Lebesgue measure, at a slight computational
% overhead (randn + normalization, as opposed to rand ).
%
% (c) Ofek Shilon , 2006.

M = zeros(n, k); % prealloc
A = zeros(n, k);
% gram-schmidt on random column vectors

vi = randn(n, 1);
% the n-dimensional normal distribution has spherical symmetry, which implies
% that after normalization the drawn vectors would be uniformly distributed on the
% n-dimensional unit sphere.
M(:, 1) = vi;
A(:, 1) = vi ./ norm(vi);

for i = 2:k
    nrm = 0;
    vi = randn(n, 1);
    vi = vi - A(:, 1:i - 1) * (A(:, 1:i - 1).' * vi);
    nrm = norm(vi);
    A(:, i) = vi ./ nrm;
    P = (n - i + 1) / n;
    M(:, i) = vi ./ P;
end
