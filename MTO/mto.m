function MTOData = mto(varargin)
%% MTO Platform (MToP)
% GUI: directly run 'mto'
% Command-Line Examples:
%   mto({MFEA, MFDE},{CMT1, CMT2})
%   mto({MFEA, MFDE},{CMT1, CMT2}, 5, true, 100, false, 'MTOData.mat', 2333)
%   mto({MFEA, MFDE},{CMT1, CMT2}, 'Reps', 5, 'Par_Flag', true)
% Input:
%   AlgoCell: Cell array of algorithm objects or names
%   ProbCell: Cell array of problem objects or names
%   'Reps' (optional): Number of independent runs (default: 1)
%   'Par_Flag' (optional): true/false for parallel calculation (default: false)
%   'Results_Num' (optional): Number of results to save (default: 50)
%   'Save_Dec' (optional): true/false for saving decision variables (default: false)
%   'Save_Name' (optional): Name of the saved .mat file (default: 'MTOData.mat')
%   'Global_Seed' (optional): Seed for random number generator (default: random)

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

cd(fileparts(mfilename('fullpath')));
addpath(genpath(pwd));

if nargin == 0
    % run with GUI
    MTO_GUI();
elseif nargin >= 2
    % run with command line, return data
    MTOData = MTO_CMD(varargin{:});
else
    error('Invalid number of input arguments.');
end

end
