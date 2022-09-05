function converge_matrix = cell2matrix(converge_cell)
    %% Map the convergence from cell to matrix
    % Input: converge_cell
    % Output: converge_matrix

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------
    
    % calculate max generation of all convergence
    max_gen = length(converge_cell{1});
    for i = 2:length(converge_cell)
        len = length(converge_cell{i});
        if len > max_gen
           max_gen = len;
        end
    end
    
    % make all convergence be the same generation
    converge_matrix = [];
    for i = 1:length(converge_cell)
        len = length(converge_cell{i});
        if len < max_gen
            converge_matrix(i, :) = [converge_cell{i}, converge_cell{i}(end) * ones(1,max_gen-len)];
        else
            converge_matrix(i, :) = converge_cell{i};
        end
    end
end