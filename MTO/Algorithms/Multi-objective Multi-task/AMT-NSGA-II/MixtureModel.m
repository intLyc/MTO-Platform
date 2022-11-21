classdef MixtureModel % Works reliably for 2(+) Dimensional distributions
    properties
        model_list; % cell array of ProbabilityModels
        alpha; % weights of the models in stacking of mixture models
        noms; % number of models
        probtable; % Probability table required for stacking EM algorithm
        nsols; % number of solutions in probability table
    end
    methods (Static)
        function mmodel = MixtureModel(allmodels)
            mmodel.model_list = allmodels;
            mmodel.noms = length(allmodels);
            mmodel.alpha = (1 / mmodel.noms) * ones(1, mmodel.noms);
        end
        function mmodel = EMstacking(mmodel)
            iterations = 100;
            for i = 1:iterations
                talpha = mmodel.alpha;
                probvector = mmodel.probtable * talpha';
                for j = 1:mmodel.noms
                    talpha(j) = sum((1 / mmodel.nsols) * talpha(j) * mmodel.probtable(:, j) ./ probvector);
                end
                mmodel.alpha = talpha;
            end
        end
        function mmodel = mutate(mmodel)
            modifalpha = max(mmodel.alpha + normrnd(0, 0.01, [1, mmodel.noms]), 0); % % % % % % % % Determining std dev for mutation can be a parameteric study % % % % % % % % % % % % % % % %
            pusum = sum(modifalpha);
            if pusum == 0 % Then complete weightage assigned to target model alone
                mmodel.alpha = zeros(1, mmodel.noms);
                mmodel.alpha(mmodel.noms) = 1;
            else
                mmodel.alpha = modifalpha / pusum;
            end
        end
        function solutions = sample(mmodel, nos)
            indsamples = ceil(nos * mmodel.alpha);
            totalsamples = sum(indsamples);
            solutions = [];
            for i = 1:mmodel.noms
                if indsamples(i) == 0
                    continue;
                else
                    sols = ProbabilityModel.sample(mmodel.model_list{i}, indsamples(i));
                    solutions = [solutions; sols];
                end
            end
            solutions = solutions(randperm(totalsamples), :);
            solutions = solutions(1:nos, :);
        end
        function mmodel = createtable(mmodel, solutions, CV, type)
            if CV
                mmodel.noms = mmodel.noms + 1; % % % % % % NOTE: Last model in the list is the target model
                mmodel.model_list{mmodel.noms} = ProbabilityModel(type);
                mmodel.model_list{mmodel.noms} = ProbabilityModel.buildmodel(mmodel.model_list{mmodel.noms}, solutions);
                mmodel.alpha = (1 / mmodel.noms) * ones(1, mmodel.noms);
                nos = size(solutions, 1);
                mmodel.probtable = ones(nos, mmodel.noms);
                for j = 1:mmodel.noms - 1
                    mmodel.probtable(:, j) = ProbabilityModel.pdfeval(mmodel.model_list{j}, solutions);
                end
                for i = 1:nos % Leave-one-out cross validation scheme
                    x = [solutions(1:i - 1, :); solutions(i + 1:nos, :)];
                    tmodel = ProbabilityModel(type);
                    tmodel = ProbabilityModel.buildmodel(tmodel, x);
                    mmodel.probtable(i, mmodel.noms) = ProbabilityModel.pdfeval(tmodel, solutions(i, :));
                end
            else
                nos = size(solutions, 1);
                mmodel.probtable = ones(nos, mmodel.noms);
                for j = 1:mmodel.noms
                    mmodel.probtable(:, j) = ProbabilityModel.pdfeval(mmodel.model_list{j}, solutions);
                end
            end
            mmodel.nsols = nos;
        end
    end
end
