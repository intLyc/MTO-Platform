function Results = MakeGenEqual(Results)
% Make Results Gen Equal for All Reps

for prob = 1:size(Results, 1)
    for algo = 1:size(Results, 2)
        maxGen = 0;
        for rep = 1:size(Results, 3)
            Gen = size(Results(prob, algo, rep).Obj, 2);
            if maxGen < Gen
                maxGen = Gen;
            end
        end

        for rep = 1:size(Results, 3)
            Gen = size(Results(prob, algo, rep).Obj, 2);
            if Gen < maxGen
                for g = Gen + 1:maxGen
                    Results(prob, algo, rep).Obj(:, g) = Results(prob, algo, rep).Obj(:, Gen);
                    Results(prob, algo, rep).CV(:, g) = Results(prob, algo, rep).CV(:, Gen);
                    if isfield(Results(prob, algo, rep), 'Dec')
                        Results(prob, algo, rep).Obj(:, g) = Results(prob, algo, rep).Obj(:, Gen);
                    end
                end
            end
        end
    end
end
end
