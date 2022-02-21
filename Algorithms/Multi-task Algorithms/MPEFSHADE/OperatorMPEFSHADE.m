classdef OperatorMPEFSHADE < OperatorSHADE
    methods (Static)
        function [offspring, calls] = generate(callfun, population, Tasks, rmp, F, pCR)
            if isempty(population)
                offspring = population;
                calls = 0;
                return;
            end
            Individual_class = class(population(1));
            % get top 100p% individuals
            for i = 1:length(population)
                factorial_costs(i) = population(i).factorial_costs;
            end
            [~, rank] = sort(factorial_costs);
            pop_pbest = rank(1:round(p * length(population)));
            group = cell([1, length(Tasks)]);
            for i = 1:length(population)
                group{population(i).skill_factor} = [group{population(i).skill_factor}, i];
            end
            Flag=zeros(1,pop);
            for i= 1:length(population)
                offspring(i) = feval(Individual_class);
                offspring(i).factorial_costs = inf(1, length(Tasks));
                pbest = pop_pbest(randi(length(pop_pbest)));
                other = [];
                for t = 1:length(group)
                    if population(i).skill_factor ~= t
                        other = [other, group{t}];
                    end
                end
                other = other(randperm(length(other)));
                A = randperm(length(group{population(i).skill_factor}));
                A = group{population(i).skill_factor}(A);
                A(A == i) = [];
                x1 = A(1); 
                %mutation
                if rand < rmp
                    x2 = other(mod(2 - 1, length(other)) + 1);
                    x3 = other(mod(3 - 1, length(other)) + 1);
                    offspring(i)=offspring(i).rnvec + F* (pbest.rnvec - offspring(i).rnvec) + F* (x2.rnvec - x3.rnvec);
                    Flag(i)=1; % the ith  individual use information communication
                else
                    x2 = A(mod(2 - 1, length(A)) + 1);
                    offspring(i)=OperatorJADE.mutate_current_pbest_1(offspring(i), population(i), population(pbest), population(x1), population(x2));
                end
                
                %crossover
                offspring(i) = OperatorJADE.crossover(offspring(i), population(i));
                
                offspring(i).rnvec(offspring(i).rnvec > 1) = 1;
                offspring(i).rnvec(offspring(i).rnvec < 0) = 0;
            end 
            if callfun
                offspring_temp = feval(Individual_class).empty();
                calls = 0;
                for t = 1:length(Tasks)
                    offspring_t = offspring([offspring.skill_factor] == t);
                    [offspring_t, cal] = evaluate(offspring_t, Tasks(t), t);
                    offspring_temp = [offspring_temp, offspring_t];
                    calls = calls + cal;
                end
                offspring = offspring_temp;
            else
                calls = 0;
            end
        end
    end
end