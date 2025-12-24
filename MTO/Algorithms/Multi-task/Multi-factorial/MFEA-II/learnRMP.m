%% Optimized and modified version of learnRMP
function rmpMatrix = learnRMP(subpops, vars)
numtasks = length(subpops);
maxDim = max(vars);
rmpMatrix = eye(numtasks);

% Add noise and Build probabilistic models
probmodel = struct('mean', cell(1, numtasks), 'stdev', cell(1, numtasks), 'nsamples', cell(1, numtasks));

for i = 1:numtasks
    probmodel(i).nsamples = size(subpops(i).data, 1);
    nrandsamples = floor(0.1 * probmodel(i).nsamples);
    randMat = rand(nrandsamples, maxDim);
    combinedData = [subpops(i).data; randMat];
    probmodel(i).mean = mean(combinedData);
    probmodel(i).stdev = std(combinedData);
end

% Pre-define constant for Gaussian PDF calculation
c1 = sqrt(2 * pi);

for i = 1:numtasks
    for j = i + 1:numtasks
        Dim = min([vars(i), vars(j)]);

        % --- Vectorized Optimization (learnRMP) ---
        data_i = subpops(i).data(:, 1:Dim);
        data_j = subpops(j).data(:, 1:Dim);

        mu_i = probmodel(i).mean(1:Dim);
        sig_i = probmodel(i).stdev(1:Dim);
        mu_j = probmodel(j).mean(1:Dim);
        sig_j = probmodel(j).stdev(1:Dim);

        % Calculate Probabilities for Task i data
        prob_ii_matrix = (1 ./ (sig_i .* c1)) .* exp(-0.5 .* ((data_i - mu_i) ./ sig_i).^2);
        lik_ii = prod(prob_ii_matrix, 2);

        prob_ij_matrix = (1 ./ (sig_j .* c1)) .* exp(-0.5 .* ((data_i - mu_j) ./ sig_j).^2);
        lik_ij = prod(prob_ij_matrix, 2);

        % Calculate Probabilities for Task j data
        prob_ji_matrix = (1 ./ (sig_i .* c1)) .* exp(-0.5 .* ((data_j - mu_i) ./ sig_i).^2);
        lik_ji = prod(prob_ji_matrix, 2);

        prob_jj_matrix = (1 ./ (sig_j .* c1)) .* exp(-0.5 .* ((data_j - mu_j) ./ sig_j).^2);
        lik_jj = prod(prob_jj_matrix, 2);

        popdata(1).probmatrix = [lik_ii, lik_ij];
        popdata(2).probmatrix = [lik_ji, lik_jj];

        rmpMatrix(i, j) = max([0, fminbnd(@(x)loglik(x, popdata, numtasks), 0, 1) + normrnd(0, 0.01)]);
        rmpMatrix(i, j) = min(rmpMatrix(i, j), 1);
        rmpMatrix(j, i) = rmpMatrix(i, j);
    end
end
end

function f = loglik(rmp, popdata, ntasks)
% --- Optimized loglik: Vectorized and Loop-free ---

% Precompute scalar coefficients for weighting
% Factor represents the probability mass transferred between tasks
factor = 0.5 * (ntasks - 1) * rmp / ntasks;
w_same = 1 - factor;
w_diff = factor;

% Extract matrices to local variables (faster access)
P1 = popdata(1).probmatrix;
P2 = popdata(2).probmatrix;

% Direct vectorized calculation of the weighted sum
% For i=1 (Task i data):
% Col 1 (j=i) uses w_same, Col 2 (j!=i) uses w_diff
prob_sum_1 = P1(:, 1) * w_same + P1(:, 2) * w_diff;

% For i=2 (Task j data):
% Col 1 (j=i for probmodel i, which is diff task for data j) uses w_diff
% Col 2 (j=j for probmodel j, which is same task for data j) uses w_same
prob_sum_2 = P2(:, 1) * w_diff + P2(:, 2) * w_same;

% Sum of negative log likelihoods
f = -sum(log(prob_sum_1)) - sum(log(prob_sum_2));
end

%% Original version of learnRMP for MFEA-II
% There are two inputs. subpops(i).data corresponds to the population
% corresponding to the ith task; vars(i) is the number of design variables
% of the ith task.
function rmpMatrix = learnRMP_old(subpops, vars)
numtasks = length(subpops);
maxDim = max(vars);
rmpMatrix = eye(numtasks);
% Add noise and Build probabilistic models
for i = 1:numtasks
    probmodel(i).nsamples = size(subpops(i).data, 1);
    nrandsamples = floor(0.1 * probmodel(i).nsamples);
    randMat = rand(nrandsamples, maxDim);
    probmodel(i).mean = mean([subpops(i).data; randMat]); % Univariate distribution mean
    probmodel(i).stdev = std([subpops(i).data; randMat]); % Univariate distribution standard deviation
end

for i = 1:numtasks
    for j = i + 1:numtasks
        popdata(1).probmatrix = ones(probmodel(i).nsamples, 2);
        popdata(2).probmatrix = ones(probmodel(j).nsamples, 2);
        Dim = min([vars(i), vars(j)]);

        for k = 1:probmodel(i).nsamples
            for l = 1:Dim
                popdata(1).probmatrix(k, 1) = popdata(1).probmatrix(k, 1) * pdf('Normal', subpops(i).data(k, l), probmodel(i).mean(l), probmodel(i).stdev(l));
                popdata(1).probmatrix(k, 2) = popdata(1).probmatrix(k, 2) * pdf('Normal', subpops(i).data(k, l), probmodel(j).mean(l), probmodel(j).stdev(l));
            end
        end
        for k = 1:probmodel(j).nsamples
            for l = 1:Dim
                popdata(2).probmatrix(k, 1) = popdata(2).probmatrix(k, 1) * pdf('Normal', subpops(j).data(k, l), probmodel(i).mean(l), probmodel(i).stdev(l));
                popdata(2).probmatrix(k, 2) = popdata(2).probmatrix(k, 2) * pdf('Normal', subpops(j).data(k, l), probmodel(j).mean(l), probmodel(j).stdev(l));
            end
        end
        rmpMatrix(i, j) = max([0, fminbnd(@(x)loglik_old(x, popdata, numtasks), 0, 1) + normrnd(0, 0.01)]); %fminbnd(@(x)loglik(x,popdata,numtasks),0,1)
        rmpMatrix(i, j) = min(rmpMatrix(i, j), 1);
        rmpMatrix(j, i) = rmpMatrix(i, j);
    end
end
end

function f = loglik_old(rmp, popdata, ntasks)
f = 0;
for i = 1:2
    for j = 1:2
        if i == j
            popdata(i).probmatrix(:, j) = popdata(i).probmatrix(:, j) * (1 - (0.5 * (ntasks - 1) * rmp / ntasks));
        else
            popdata(i).probmatrix(:, j) = popdata(i).probmatrix(:, j) * 0.5 * (ntasks - 1) * rmp / ntasks;
        end
    end
    f = f + sum(-log(sum(popdata(i).probmatrix, 2)));
end
end
