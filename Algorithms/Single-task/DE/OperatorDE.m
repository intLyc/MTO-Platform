classdef OperatorDE < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function object = mutate(object, x1, x2, x3, F)
            object.rnvec = x1.rnvec + F * (x2.rnvec - x3.rnvec);
        end

        function object = crossover(object, x, CR)
            replace = rand(1, length(object.rnvec)) > CR;
            replace(randi(length(object.rnvec))) = true;
            object.rnvec(replace) = x.rnvec(replace);
        end

        function [offspring, calls] = generate(callfun, population, Task, F, CR, varargin)
            % DE mutate type
            n = numel(varargin);
            if n == 0
                mutate_type = 'rand_1'; % unified [0, 1]
            elseif n == 1
                mutate_type = varargin{1};
            end

            if length(population) <= 3
                offspring = population;
                calls = 0;
                return;
            end
            Individual_class = class(population(1));
            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                switch mutate_type
                    case 'rand_1'
                        A = randperm(length(population), 4);
                        A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
                    case 'current_rand'
                        r = randi(length(population));
                        while r == i
                            r = randi(length(population));
                        end
                        x1 = i; x2 = r; x3 = i;
                end

                offspring(i) = OperatorDE.mutate(offspring(i), population(x1), population(x2), population(x3), F);
                offspring(i) = OperatorDE.crossover(offspring(i), population(i), CR);

                % offspring(i).rnvec(offspring(i).rnvec > 1) = 1;
                % offspring(i).rnvec(offspring(i).rnvec < 0) = 0;
                rand_rnvec = rand(1, Task.dims);
                offspring(i).rnvec(offspring(i).rnvec > 1) = rand_rnvec(offspring(i).rnvec > 1);
                offspring(i).rnvec(offspring(i).rnvec < 0) = rand_rnvec(offspring(i).rnvec < 0);
            end
            if callfun
                [offspring, calls] = evaluate(offspring, Task, 1);
            else
                calls = 0;
            end
        end
    end
end
