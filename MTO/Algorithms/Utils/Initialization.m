function population = Initialization(Algo, Prob, Individual_Class, varargin)
    %% Multi-task - Initialize and evaluate the population
    % Input: Algorithm, Problem, Individual_Class
    % Output: population

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    n = numel(varargin);
    if n == 0
        gene_type = 'unified'; % unified [0, 1]
    elseif n == 1
        gene_type = varargin{1};
    else
        return;
    end

    for t = 1:Prob.T
        for i = 1:Prob.N
            population{t}(i) = Individual_Class();
            switch gene_type
                case 'unified'
                    population{t}(i).Dec = rand(1, max(Prob.D));
                case 'real'
                    population{t}(i).Dec = (Prob.Ub{t} - Prob.Lb{t}) .* rand(1, max(Prob.D)) + Prob.Lb{t};
            end
        end
        population{t} = Algo.Evaluation(population{t}, Prob, t);
    end
end
