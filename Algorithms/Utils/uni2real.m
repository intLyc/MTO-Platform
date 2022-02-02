function X = uni2real(X, Tasks)
    %% Map the unified [0,1] rnvec to real bound
    % Input: X (unified [0,1] rnvec), Tasks
    % Output: X (real bound rnvec)
    
    for t = 1:length(Tasks)
        X{t} = Tasks(t).Lb + X{t}(1:Tasks(t).dims) .* (Tasks(t).Ub - Tasks(t).Lb);
    end
end
