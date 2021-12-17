function [inj_solution] = mDA(curr_pop, his_pop, his_bestSolution)
    % curr_pop and his_pop denote the current population and
    %population from another domain. Both in the form of n*d matrix. %n is the number of individual, and d is the variable dimension.
    %They do not have to be with the same d. We assume they have the %%same n (same population size)

    % his_bestSolution is the best solutions from one domain.

    %output is the transformed solution.

    curr_len = size(curr_pop, 2);
    tmp_len = size(his_pop, 2);

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
