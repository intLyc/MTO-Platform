function MTO_CMD(AlgoCell, ProbCell, Reps, ParFlag, SaveName)
    %% MTO Platform run with command line, save data in mat file
    % Input: algorithms char cell, problems char cell, Reps, parallel flag, save file name
    % Output: none

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    if isa(AlgoCell, 'char')
        AlgoCell = {AlgoCell};
    end
    if isa(ProbCell, 'char')
        ProbCell = {ProbCell};
    end
    AlgoCell = strrep(AlgoCell, '-', '_');
    ProbCell = strrep(ProbCell, '-', '_');

    % Create Algorithm and Problem Object cell
    AlgoObject = {};
    for algo = 1:length(AlgoCell)
        eval(['algo_obj = ', AlgoCell{algo}, '(''', strrep(AlgoCell{algo}, '_', '-'), '''); ']);
        AlgoObject = [AlgoObject, {algo_obj}];
    end
    ProbObject = {};
    for prob = 1:length(ProbCell)
        eval(['prob_obj = ', ProbCell{prob}, '(''', strrep(ProbCell{prob}, '_', '-'), '''); ']);
        ProbObject = [ProbObject, {prob_obj}];
    end

    % Set Data
    Data.Reps = Reps;
    Data.Problems = [];
    for prob = 1:length(ProbObject)
        Data.Problems(prob).Name = ProbObject{prob}.Name;
        Data.Problems(prob).T = ProbObject{prob}.T;
        Data.Problems(prob).M = ProbObject{prob}.M;
        Data.Problems(prob).D = ProbObject{prob}.D;
        Data.Problems(prob).N = ProbObject{prob}.N;
        Data.Problems(prob).Fnc = ProbObject{prob}.Fnc;
        Data.Problems(prob).Lb = ProbObject{prob}.Lb;
        Data.Problems(prob).Ub = ProbObject{prob}.Ub;
        Data.Problems(prob).maxFE = ProbObject{prob}.maxFE;
    end
    Data.Algorithms = [];
    for algo = 1:length(AlgoObject)
        Data.Algorithms(algo).Name = AlgoObject{algo}.Name;
        Data.Algorithms(algo).Para = AlgoObject{algo}.getParameter();
    end
    Data.Results = {};
    Data.RunTimes = [];
    Results = {};

    % Run
    for prob = 1:length(ProbObject)
        disp(['Problem: ', char(ProbObject{prob}.Name)]);
        for algo = 1:length(AlgoObject)
            disp(['Algorithm: ', char(AlgoObject{algo}.Name)]);
            if ParFlag
                par_tool = Par(Reps);
                parfor rep = 1:Reps
                    Par.tic
                    AlgoObject{algo}.run(ProbObject{prob});
                    Results{prob, algo, rep} = AlgoObject{algo}.getResult();
                    AlgoObject{algo}.reset();
                    par_tool(rep) = Par.toc;
                end
                Data.RunTimes(prob, algo) = sum([par_tool.ItStop] - [par_tool.ItStart]);
            else
                t_temp = tic;
                for rep = 1:Reps
                    AlgoObject{algo}.run(ProbObject{prob});
                    Results{prob, algo, rep} = AlgoObject{algo}.getResult();
                    AlgoObject{algo}.reset();
                end
                Data.RunTimes(prob, algo) = toc(t_temp);
            end
        end
        % save temporary data
        % Data.Results = MakeGenEqual(Results);
        % MTOData = Data;
        % MTOData.Problems = MTOData.Problems(1:prob);
        % save('MTOData_Temp', 'MTOData');
    end

    % save mat file
    Data.Results = MakeGenEqual(Results);
    MTOData = Data;
    save(SaveName, 'MTOData');
end
