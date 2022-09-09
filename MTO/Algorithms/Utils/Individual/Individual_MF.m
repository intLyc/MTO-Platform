classdef Individual_MF < Individual

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties
        % multifactorial parameter
        MFObj % multifactorial Objective
        MFCV % multifactorial Constraint Violation
        MFRank % multifactorial rank
        MFFactor % multifactorial Skill Factor
    end
end
