function result = Run_Time(MTOData)
    % <Table>

    % Run Time

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    result.RowName = {MTOData.Problems.Name};
    result.ColumnName = {MTOData.Algorithms.Name};
    result.TableData = MTOData.RunTimes;
end
