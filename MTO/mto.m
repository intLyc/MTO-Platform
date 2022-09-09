function mto(varargin)
    %% MTO Platform
    % GUI: 'mto'
    % Command line: 'mto(AlgoCell, ProbCell, Reps, ParFlag, SaveName)'

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
        ParFlag = 1;
        SaveName = 'MTOData';
        AlgoCell = varargin{1};
        ProbCell = varargin{2};
        if length(varargin) >= 3
            Reps = varargin{3};
        end
        if length(varargin) >= 4
            ParFlag = varargin{4};
        end
        if length(varargin) >= 5
            SaveName = varargin{5};
        end
        MTO_CMD(AlgoCell, ProbCell, Reps, ParFlag, SaveName);
    end
end
