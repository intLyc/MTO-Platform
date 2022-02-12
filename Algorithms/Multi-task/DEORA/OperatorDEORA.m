classdef OperatorDEORA < OperatorDE
    methods (Static)
        function [offspring, r1_task, calls] = generate(callfun, population, Tasks, k, rmp, F, pCR)
            if isempty(population{k})
                offspring = population{k};
                calls = 0;
                return;
            end
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

                offspring(i) = OperatorDE.mutate_rand_1(offspring(i), population{r1_task(i)}(x1), population{k}(x2), population{k}(x3), F);
                offspring(i) = OperatorDE.crossover(offspring(i), population{k}(i), pCR);

                offspring(i).rnvec(offspring(i).rnvec > 1) = 1;
                offspring(i).rnvec(offspring(i).rnvec < 0) = 0;
            end
            if callfun
                [offspring, calls] = evaluate(offspring, Tasks(k), 1);
            else
                calls = 0;
            end
        end
    end
end
