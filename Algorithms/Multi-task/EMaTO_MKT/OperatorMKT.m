classdef OperatorMKT < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(callfun, population, Tasks, amp, mu, mum, cluster_model)
            if isempty(population)
                offspring = population;
                calls = 0;
                return;
            end
            Individual_class = class(population{1}(1));
            offspring = {};
            for t = 1:length(Tasks)
                indorder = randperm(length(population{t}));
                count = 1;
                for i = 1:ceil(length(population{t}) / 2)
                    p1 = indorder(i);
                    p2 = indorder(i + fix(length(population{t}) / 2));
                    offspring{t}(count) = feval(Individual_class);
                    offspring{t}(count + 1) = feval(Individual_class);

                    u = rand(1, max([Tasks.dims]));
                    cf = zeros(1, max([Tasks.dims]));
                    cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                    cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                    if rand < amp(t)
                        offspring{t}(count) = OperatorGA.crossover(offspring{t}(count), population{t}(p1), population{t}(p2), cf);
                        offspring{t}(count + 1) = OperatorGA.crossover(offspring{t}(count + 1), population{t}(p2), population{t}(p1), cf);
                        offspring{t}(count) = OperatorGA.mutate(offspring{t}(count), max([Tasks.dims]), mum);
                        offspring{t}(count + 1) = OperatorGA.mutate(offspring{t}(count + 1), max([Tasks.dims]), mum);
                    else
                        % knowledge tansfer
                        current_mean = cluster_model(t).Nich_mean(population{t}(p1).cluster_num, :);
                        current_std = cluster_model(t).Nich_std(population{t}(p1).cluster_num, :);
                        offspring{t}(count).rnvec = normrnd(current_mean, current_std);
                        offspring{t}(count + 1).rnvec = normrnd(current_mean, current_std);
                    end

                    for x = count:count + 1
                        offspring{t}(x).rnvec(offspring{t}(x).rnvec > 1) = 1;
                        offspring{t}(x).rnvec(offspring{t}(x).rnvec < 0) = 0;
                    end
                    count = count + 2;
                end
            end
            if callfun
                calls = 0;
                for t = 1:length(Tasks)
                    [offspring{t}, cal] = evaluate(offspring{t}, Tasks(t), 1);
                    calls = calls + cal;
                end
            else
                calls = 0;
            end
        end
    end
end
