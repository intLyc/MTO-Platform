classdef OperatorDEORA < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, r1_task, calls] = generate(population, Tasks, k, rmp, F, CR)
            Individual_class = class(population{k}(1));

            r1_task = zeros(1, length(population{k}));
            for i = 1:length(population{k})
                offspring(i) = feval(Individual_class);

                rnd = randperm(length(population{k}), 3);
                x1 = rnd(1); x2 = rnd(2); x3 = rnd(3);

                r = rand();
                for t = 1:length(Tasks)
                    if r <= sum(rmp(k, 1:t))
                        r1_task(i) = t;
                        break;
                    end
                end

                offspring(i) = OperatorDEORA.mutate(offspring(i), population{r1_task(i)}(x1), population{k}(x2), population{k}(x3), F);
                offspring(i) = OperatorDEORA.crossover(offspring(i), population{k}(i), CR);

                vio_low = find(offspring(i).rnvec < 0);
                offspring(i).rnvec(vio_low) = (population{k}(i).rnvec(vio_low) + 0) / 2;
                vio_up = find(offspring(i).rnvec > 1);
                offspring(i).rnvec(vio_up) = (population{k}(i).rnvec(vio_up) + 1) / 2;
            end
            [offspring, calls] = evaluate(offspring, Tasks(k), 1);
        end

        function object = mutate(object, x1, x2, x3, F)
            object.rnvec = x1.rnvec + F * (x2.rnvec - x3.rnvec);
        end

        function object = crossover(object, x, CR)
            replace = rand(1, length(object.rnvec)) > CR;
            replace(randi(length(object.rnvec))) = false;
            object.rnvec(replace) = x.rnvec(replace);
        end
    end
end
