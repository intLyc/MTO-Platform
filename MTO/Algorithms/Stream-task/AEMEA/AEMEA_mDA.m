function [inj_solution] = AEMEA_mDA(curr_pop, his_pop, his_bestSolution)
% Map source elites to the target; training populations share row counts but may differ in dimension.

curr_len = size(curr_pop, 2);
tmp_len = size(his_pop, 2);

% Zero-pad lower-dimensional data before fitting the linear mapping.
if curr_len < tmp_len
    curr_pop(:, curr_len + 1:tmp_len) = 0;
elseif curr_len > tmp_len
    his_pop(:, tmp_len + 1:curr_len) = 0;
end

xx = curr_pop';
noise = his_pop';

[d, n] = size(xx);
xxb = [xx; ones(1, n)];

noise_xb = [noise; ones(1, n)];

Q = noise_xb * noise_xb';

P = xxb * noise_xb';
lambda = 1e-5;
reg = lambda * eye(d + 1);
reg(end, end) = 0;
% Regularize the solve while leaving the final bias coordinate unpenalized.
W = P / (Q + reg);

tmmn = size(W, 1);
W(tmmn, :) = [];
W(:, tmmn) = [];

if curr_len <= tmp_len
    tmp_solution = (W * his_bestSolution')';
    inj_solution = tmp_solution(:, 1:curr_len);
elseif curr_len > tmp_len
    his_bestSolution(:, tmp_len + 1:curr_len) = 0;
    inj_solution = (W * his_bestSolution')';
end

end
