classdef ProbabilityModel % Works reliably for 2(+) Dimensional distributions
properties
    modeltype; % multivariate normal ('mvarnorm' - for real coded) or univariate marginal distribution ('umd' - for binary coded)
    mean_noisy;
    mean_true;
    covarmat_noisy;
    covarmat_true;
    probofone_noisy;
    probofone_true;
    probofzero_noisy;
    probofzero_true;
    vars;
end
methods (Static)
    function model = ProbabilityModel(type)
        model.modeltype = type;
    end
    function solutions = sample(model, nos)
        if strcmp(model.modeltype, 'mvarnorm')
            solutions = mvnrnd(model.mean_true, model.covarmat_true, nos);
        elseif strcmp(model.modeltype, 'umd')
            solutions = rand(nos, model.vars);
            for i = 1:nos
                index1 = solutions(i, :) <= model.probofone_true;
                index0 = solutions(i, :) > model.probofone_true;
                solutions(i, index1) = 1;
                solutions(i, index0) = 0;
            end
        end
    end
    function probofsols = pdfeval(model, solutions)
        if strcmp(model.modeltype, 'mvarnorm')
            probofsols = mvnpdf(solutions, model.mean_noisy, model.covarmat_noisy);
        elseif strcmp(model.modeltype, 'umd')
            nos = size(solutions, 1);
            probofsols = zeros(nos, 1);
            probvector = zeros(1, model.vars);
            for i = 1:nos
                index = solutions(i, :) == 1;
                probvector(index) = model.probofone_noisy(index);
                index = solutions(i, :) == 0;
                probvector(index) = model.probofzero_noisy(index);
                probofsols(i) = prod(probvector);
            end
        end
    end
    function model = buildmodel(model, solutions)
        [pop, model.vars] = size(solutions);
        if strcmp(model.modeltype, 'mvarnorm')
            model.mean_true = mean(solutions);
            covariance = cov(solutions);
            model.covarmat_true = diag(diag(covariance)); % Simplifying to univariate distribution by ignoring off diagonal terms of covariance matrix
            solutions_noisy = [solutions; rand(round(0.1 * pop), model.vars)];
            model.mean_noisy = mean(solutions_noisy);
            covariance = cov(solutions_noisy);
            model.covarmat_noisy = diag(diag(covariance)); % Simplifying to univariate distribution by ignoring off diagonal terms of covariance matrix
            % model.covarmat_noisy = cov(solutions_noisy);
        elseif strcmp(model.modeltype, 'umd')
            model.probofone_true = mean(solutions);
            model.probofzero_true = 1 - model.probofone_true;
            solutions_noisy = [solutions; round(rand(round(0.1 * pop), model.vars))];
            model.probofone_noisy = mean(solutions_noisy);
            model.probofzero_noisy = 1 - model.probofone_noisy;
        end
    end
end
end
