function result = Min_Objective(MTOData)
    % <Table>

    % Minimal Objective Value of All Tasks

    %------------------------------- Reference --------------------------------
    % @Article{Li2022CompetitiveMTO,
    %   author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   title      = {Evolutionary Competitive Multitasking Optimization},
    %   year       = {2022},
    %   pages      = {1-1},
    %   doi        = {10.1109/TEVC.2022.3141819},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    result.RowName = {MTOData.Problems.Name};
    result.ColumnName = {MTOData.Algorithms.Name};

    % Calculate Minimal Objective
    result.TableData = [];
    for prob = 1:length(MTOData.Problems)
        for algo = 1:length(MTOData.Algorithms)
            MinObj = zeros(1, MTOData.Reps);
            for rep = 1:MTOData.Reps
                temp = MTOData.Results{prob, algo, rep}{:, end};
                Obj_temp = [temp.Obj];
                CV_temp = [temp.CV];
                Obj_temp(CV_temp > 0) = NaN;
                MinObj(rep) = min(Obj_temp);
            end
            result.TableData(prob, algo, :) = MinObj;
        end
    end
end