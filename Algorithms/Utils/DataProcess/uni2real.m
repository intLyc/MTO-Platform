function X = uni2real(X, Tasks)
    %% Map the unified [0,1] rnvec to real bound
    % Input: X (unified [0,1] rnvec), Tasks
    % Output: X (real bound rnvec)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    for t = 1:length(Tasks)
        X{t} = Tasks(t).Lb + X{t}(1:Tasks(t).Dim) .* (Tasks(t).Ub - Tasks(t).Lb);
    end
end
