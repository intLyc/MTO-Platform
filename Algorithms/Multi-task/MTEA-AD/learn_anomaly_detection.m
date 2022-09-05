function tfsol = learn_anomaly_detection(curr_pop, his_pop, NL)
    %% Learning anomaly detection model of task tn
    % Input: curr_pop (Dec matrix), his_pop (Dec matrix), NL (anomaly detection parameter)
    % Output: tfsol (candidate transferred solutions)

    % Sample, make sure that the fitted covariance is a square, symmetric, positive definite matrix.
    nsamples = floor(0.01 * size(curr_pop, 1));
    randMat = rand(nsamples, size(curr_pop, 2));
    curr_pop = [curr_pop; randMat];

    % Fit
    mmean = mean(curr_pop);
    sstd1 = cov(curr_pop);
    sstd = sstd1 + (10e-6) * eye(size(curr_pop, 2));

    % Calculate the scores
    [Dec, ~] = unique(his_pop, 'rows');
    Y = mvnpdf(Dec(:, 1:size(curr_pop, 2)), mmean, sstd);

    % Select the candidate transferred solutions
    [~, ii] = sort(Y, 'descend');
    if NL == 0
        mm = Y(1); % Ensure that the number of transferred individuals is not 0
    else
        mm = Y(ii(ceil(size(Y, 1) * NL)));
    end

    % Count the number of candidate transferred solutions
    tte = Y >= mm;
    tfsol = Dec(tte, :);
end
