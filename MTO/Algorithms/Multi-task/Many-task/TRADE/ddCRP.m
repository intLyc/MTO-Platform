function [K] = ddCRP(X)
[N, ~] = size(X);
alpha = 0.05;
rho = 10;
reps = 100;
nt = [];
dist_matrix = zeros(N);

for i = 1:N
    dist_matrix(i, i) = 1e-25;
    for j = i + 1:N
        dist_matrix(i, j) = norm(X(i, :) - X(j, :), 2);
        dist_matrix(j, i) = dist_matrix(i, j);
    end
end
expdist_matrix = exp(-dist_matrix / rho);

pr_matrix = zeros(N);
cumpr = zeros(N);

for i = 1:N
    for j = 1:N
        if i ~= j
            pr_matrix(i, j) = expdist_matrix(i, j);
        else
            pr_matrix(i, j) = alpha;
        end
    end
    pr_matrix(i, :) = pr_matrix(i, :) / sum(pr_matrix(i, :));
    cumpr(i, :) = cumsum(pr_matrix(i, :));
end

for rep = 1:reps
    ntables = 0;
    connected_customer = zeros(1, N);
    for i = 1:N
        selj = find(rand() < cumpr(i, :), 1);
        connected_customer(i) = selj;
    end
    % calculate number of formulated tables
    flags = false(1, N);
    while ~isempty(find(flags == false, 1))
        ntables = ntables + 1;
        ci = find(flags == false, 1);
        [flags] = color_visited_cust(connected_customer, ci, flags);
    end
    nt = [nt ntables];
end
K = ceil(mean(nt));
end
