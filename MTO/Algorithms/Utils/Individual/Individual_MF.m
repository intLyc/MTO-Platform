classdef Individual_MF < Individual

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties
    % multifactorial parameter
    MFObj % multifactorial Objective
    MFCV % multifactorial Constraint Violation
    MFRank % multifactorial rank
    MFFactor % multifactorial Skill Factor
end
end
