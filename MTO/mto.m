function mto(varargin)
    %% MTO Platform
    % GUI: 'mto'
    % Command line: 'mto(AlgoCell, ProbCell, Reps, Results_Num, ParFlag, SaveName)'

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
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
        Results_Num = 50;
        ParFlag = 0;
        SaveName = 'MTOData';
        AlgoCell = varargin{1};
        ProbCell = varargin{2};
        if length(varargin) >= 3
            Reps = varargin{3};
        end
        if length(varargin) >= 4
            Results_Num = varargin{4};
        end
        if length(varargin) >= 5
            ParFlag = varargin{5};
        end
        if length(varargin) >= 6
            SaveName = varargin{6};
        end
        MTO_CMD(AlgoCell, ProbCell, Reps, Results_Num, ParFlag, SaveName);
    end
end
