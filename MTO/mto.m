function mto(varargin)
%% MTO Platform
% GUI: 'mto'
% Command line: 'mto(Algo_Cell, Prob_Cell, Reps, Par_flag, Results_Num, Save_Dec, Save_Name)'

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

addpath(genpath('./Algorithms/'));
addpath(genpath('./Problems/'));
addpath(genpath('./Metrics/'));
addpath(genpath('./GUI/'));

if isempty(varargin)
    % run with GUI
    MTO_GUI();
else
    % run with command line, save data in mat file
    Reps = 1;
    Par_flag = 0;
    Results_Num = 50;
    Save_Dec = false;
    Save_Name = 'MTOData';
    Algo_Cell = varargin{1};
    Prob_Cell = varargin{2};
    if length(varargin) >= 3
        Reps = varargin{3};
    end
    if length(varargin) >= 4
        Par_flag = varargin{4};
    end
    if length(varargin) >= 5
        Results_Num = varargin{5};
    end
    if length(varargin) >= 6
        Save_Dec = varargin{6};
    end
    if length(varargin) >= 7
        Save_Name = varargin{7};
    end
    MTO_CMD(Algo_Cell, Prob_Cell, Reps, Par_flag, Results_Num, Save_Dec, Save_Name);
end
end
