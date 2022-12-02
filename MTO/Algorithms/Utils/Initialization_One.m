function population = Initialization_One(Algo, Prob, t, Individual_Class, varargin)
    %% Initialize and evaluate the population for One task
    % Input: Algorithm, Problem, task_idx, Individual_Class
    % Output: population

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    n = numel(varargin);
    if n == 0
        N = Prob.N;
    elseif n == 1
        N = varargin{1};
    else
        return;
    end

    for i = 1:N
        population(i) = Individual_Class();
        % switch gene_type
        %     case 'unified'
        population(i).Dec = rand(1, max(Prob.D));
        %     case 'real'
        %         population(i).Dec = (Prob.Ub{t} - Prob.Lb{t}) .* rand(1, max(Prob.D)) + Prob.Lb{t};
        % end
    end
    population = Algo.Evaluation(population, Prob, t);
end
