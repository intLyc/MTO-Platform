% There are two inputs. subpops(i).data corresponds to the population
% corresponding to the ith task; vars(i) is the number of design variables
% of the ith task.
function rmpMatrix = learnRMP(subpops, vars)
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
            rmpMatrix(i, j) = max([0, fminbnd(@(x)loglik(x, popdata, numtasks), 0, 1) + normrnd(0, 0.01)]); %fminbnd(@(x)loglik(x,popdata,numtasks),0,1)
            rmpMatrix(i, j) = min(rmpMatrix(i, j), 1);
            rmpMatrix(j, i) = rmpMatrix(i, j);
        end
    end
end

function f = loglik(rmp, popdata, ntasks)
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
